class Demand < ApplicationRecord

  validates_numericality_of :quantity, :allow_nil => false, :greater_than => 0
  validates_presence_of :color_id, :flower_id, :market_id, :week_id

  belongs_to :color
  belongs_to :flower
  belongs_to :market
  belongs_to :week

  class << self
    def import file_path
      demands = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          color_id = (Color.find_by(name: row["color_name"].to_s.upcase).id rescue nil)
          if color_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "COlor #{row["color_name"]} no encontrado."
            }
            next
          end

          flower_id = (Flower.find_by(name: row["flower"].to_s.upcase).id rescue nil)
          if flower_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Flor: #{row["flower"]} no encontrada."
            }
            next
          end

          market_id = (Market.find_by(code: row["market_code"].to_s.upcase).id rescue nil)
          if market_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Mercado: #{row["market_code"]} no encontrada."
            }
            next
          end

          week_id = (Week.find_by(initial_day: row["date"]).id rescue nil)
          if week_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Fecha: #{row["date"]} no encontrada."
            }
            next
          end

          demands << {
            quantity: row["quantity"],
            color_id: color_id,
            week_id: week_id,
            market_id: market_id,
            flower_id: flower_id
          }
        end

        if errors.empty?
          Demand.bulk_insert values: demands
        else
          csv_with_errors errors
        end
  end

    private
    def csv_with_errors demands_list

      attributes = %w{date color_name market_code quantity flower errores}
      file_path = "db/tmp_files/errores_demanda.csv"

      CSV.open(file_path, "wb") do |csv|

        csv << attributes
        demands_list.each do |data|
          csv << [data[:initial_values].values, data[:error]].flatten
        end
      end
      file_path
    end
  end

end
