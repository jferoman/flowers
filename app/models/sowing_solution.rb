class SowingSolution < ApplicationRecord
  validates_presence_of :week_id, :block_id, :bed_type_id, :variety_id

  belongs_to :variety
  belongs_to :week
  belongs_to :block
  belongs_to :bed_type
  belongs_to :expiration_week, :class_name => 'Week'

  class << self
    def import file_path
      sowing_solutions = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|


          variety_id = (Variety.find_by(name: row["variety_name"].to_s.upcase).id rescue nil)
          if variety_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Variedad: #{row["variety_name"]} no encontrada."
            }
            next
          end

          week = (Week.find_by(initial_day: row["date"]) rescue nil)
          if week.nil?
            errors << {
              initial_values: row.to_h,
              error: "Fecha: #{row["date"]} no encontrada."
            }
            next
          end

          block_id = (Farm.find_by(name: row["farm_name"]).blocks.find_by(name: row["block_name"].to_s.upcase).id rescue nil)
          if block_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Blque: #{row["block_name"]}, de la finca #{row["farm_name"]} no encontrado."
            }
            next
          end

          bed_type_id = (BedType.find_by(name: row["bed_type_name"].to_s.upcase).id rescue nil)
          if bed_type_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Tipo de cama #{row["bed_number"]} no encontrada."
            }
            next
          end

          sowing_solution = SowingSolution.find_by(variety_id: variety_id, block_id: block_id, week_id: week.id, bed_type_id: bed_type_id)
          if !sowing_solution.nil?
            errors << {
              initial_values: row.to_h,
              error: "El registro #{row["variety_name"]}, #{row["bed_number"]}, #{row["bed_type_name"]}, #{row["date"]}, #{row["block_name"]} ya existe."
            }
            next
          end

          cutting_week = ProductivityCurve.find_by(variety_id: variety_id, cut: row["cut"].to_i).week_number
          sowing_solutions << {
            quantity: row["quantity"],
            cutting_week: cutting_week,
            variety_id: variety_id,
            week_id: week.id,
            block_id: block_id,
            bed_type_id: bed_type_id,
            expiration_week_id: week.next_week_in( cutting_week).id
          }
        end

        if errors.empty?
          SowingSolution.bulk_insert values: sowing_solutions
        else
          csv_with_errors errors
        end
    end

    ##
    # Generate cuttings from sowing solution , for the specified farm.
    # Parameters: farm_id
    # Return: Generate cuttings for the variety and week of the sowing detail.
    #
    ##
    def generate_cuttings farm_id
      cuttings = []
      Farm.find(farm_id).sowing_solutions.group(:variety_id, :week_id, :cutting_week).sum(:quantity).each do |sowing|
        cuttings << {
          quantity: sowing[1],
          origin: "Modelo",
          cutting_week: sowing[0][2],
          farm_id: farm_id,
          week_id: sowing[0][1],
          variety_id: sowing[0][0]
        }
      end
      Cutting.bulk_insert values: cuttings
    end

    ##
    # Generate the production from the sowing detail.
    # Parameters:
    # => farm: Farm for the sowings solutions
    #
    # Generate the bed production for this sowing.
    ##
    # TODO
    def generate_block_production farm
      block_productions = []
      farm.sowing_solutions.each do |sowing_solution|
        production = 0
        (1..(sowing_solution.expiration_week.week-sowing_solution.week.week)).each do |s|

          production += (sowing_solution.quantity * sowing_solution.variety.get_productivity(s))

          block_productions << {
            quantity: production,
            origin: "Modelo",
            variety_id: sowing_solution.variety_id,
            farm_id: farm.id,
            week_id: sowing_solution.week.next_week_in(s).id,
            block_id: sowing_solution.block.id
          }

        end
      end
      BlockProduction.bulk_insert values: block_productions
    end

    private
      def csv_with_errors sowing_solution_list

        attributes = %w{date variety_name cut farm_name block_name bed_type_name quantity errores}
        file_path = "db/tmp_files/errores_detalle_siembra.csv"

        CSV.open(file_path, "wb") do |csv|

          csv << attributes
          sowing_solution_list.each do |data|
            csv << [data[:initial_values].values, data[:error]].flatten
          end
        end
        file_path
      end
  end

end
