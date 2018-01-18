class BedProduction < ApplicationRecord

  validates_presence_of :quantity, :status
  validates :status, uniqueness: { scope: [:variety_id, :bed_id, :week_id] }

  belongs_to :variety
  belongs_to :bed
  belongs_to :week

  class << self
    def import file_path
      bed_productions = []
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

          week_id = (Week.find_by(initial_day: row["week"]).id rescue nil)
          if week_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Fecha: #{row["week"]} no encontrada."
            }
            next
          end

          bed_id = (Bed.find_by(number: row["cama"].to_s.upcase).id rescue nil)
          if bed_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Cama: #{row["cama"]} no encontrada."
            }
            next
          end

          bed_production = BedßProduction.find_by(variety_id: variety_id, week_id: week_id, bed_id: bed_id, status: row["status"])
          if !bed_production.nil?
            errors << {
              initial_values: row.to_h,
              error: "El registro #{row["variety"]}, #{row["week"]}, #{row["bed"]}, Ejecutado ya existe."
            }
            next
          end

          bed_productions << {
            quantity: row["quantity"],
            status: row["status"],
            variety_id: variety_id,
            week_id: week_id,
            bed_id: bed_id
          }
        end
        if errors.empty?
          BedProduction.bulk_insert values: bed_productions
        else
          csv_with_errors errors
        end
    end

    private
    def csv_with_errors bed_productions_list

      attributes = %w{quantity variety week bed errores}
      file_path = "db/tmp_files/errores_produccion_camas.csv"

      CSV.open(file_path, "wb") do |csv|

        csv << attributes
        bed_productions_list.each do |data|
          csv << [data[:initial_values].values, data[:error]].flatten
        end
      end
      file_path
    end
  end
end
