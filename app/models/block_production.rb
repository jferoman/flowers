class BlockProduction < ApplicationRecord

  validates_presence_of :quantity
  validates :origin, uniqueness: { scope: [:variety_id, :farm_id, :week_id, :block_id, :origin] }

  belongs_to :variety
  belongs_to :farm
  belongs_to :week
  belongs_to :block

  class << self
    def import file_path
      block_productions = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          variety_id = (Variety.find_by(name: row["variety"].to_s.upcase).id rescue nil)
          if variety_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Variedad: #{row["variety"]} no encontrada."
            }
            next
          end

          farm_id = (Farm.find_by(name: row["farm"].to_s.upcase).id rescue nil)
          if farm_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Finca: #{row["farm"]} no encontrada."
            }
            next
          end

          week_id = (Week.find_by(initial_day: row["week"]).id rescue nil)
          if week_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Fecha: #{row["week"]} no encontrada."
            }
            next
          end

          block_id = (Block.find_by(name: row["bloque"].to_s.upcase).id rescue nil)
          if block_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Bloque: #{row["bloque"]} no encontrado."
            }
            next
          end

          block_production = BlockProduction.find_by(variety_id: variety_id, farm_id: farm_id, week_id: week_id, block_id: block_id, origin: row["origin"])
          if !block_production.nil?
            errors << {
              initial_values: row.to_h,
              error: "El registro #{row["variety"]}, #{row["farm"]}, #{row["week"]}, #{row["block"]}, Ejecutado ya existe."
            }
            next
          end

          block_productions << {
            quantity: row["quantity"],
            origin: row["origin"],
            variety_id: variety_id,
            farm_id: farm_id,
            week_id: week_id,
            block_id: block_id
          }
        end

        if errors.empty?
          BlockProduction.bulk_insert values: block_productions
        else
          csv_with_errors errors
        end
    end

    private
    def csv_with_errors block_productions_list

      attributes = %w{quantity variety farm week block errores}
      file_path = "db/tmp_files/errores_produccion_bloques.csv"

      CSV.open(file_path, "wb") do |csv|

        csv << attributes
        block_productions_list.each do |data|
          csv << [data[:initial_values].values, data[:error]].flatten
        end
      end
      file_path
    end
  end
end
