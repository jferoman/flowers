class Submarket < ApplicationRecord
  require 'csv'

  validates_presence_of :name, :code
  validates_uniqueness_of :code, :name

  belongs_to :market
  has_many :color_submarkets
  has_many :submarket_weeks
  has_many :weeks, through: :submarket_weeks



  class << self
    def import file_path
      submarkets = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          market_id = (Market.find_by(code: row["market_name"].to_s).id rescue nil)
          if market_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Mercado #{row["market_name"]} no encontrado."
            }
            next
          end

          submarket = Submarket.find_by(name: row["name"], code: row["code"], market_id: market_id )
          if !submarket.nil?
            errors << {
              initial_values: row.to_h,
              error: "Submercado #{row["name"]} ya existe para el mercado #{row["market_name"]}"
            }
            next
          end

          submarkets << {
            code: row["code"],
            name: row["name"],
            market_id: market_id
          }
        end

        if errors.empty?
          Submarket.bulk_insert values: submarkets
        else
          csv_with_errors(errors, ["code", "market_name", "errors"], "db/tmp_files/errores_submercados.csv")
        end
    end

    def import_submarket_weeks file_path
      submarket_weeks = []
      errors = []

      CSV.foreach(file_path, {
        encoding: "iso-8859-1:utf-8",
        headers: true,
        converters: :all,
        header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

        submarket_id = (Submarket.find_by(code: row["submarket_name"].to_s).id rescue nil)
        if submarket_id.nil?
          errors << {
            initial_values: row.to_h,
            error: " Submercado #{row["submarket_name"]} no encontrado."
          }
          next
        end

        week_id = (Week.find_by(initial_day: row["date"]).id rescue nil)
        if week_id.nil?
          errors << {
            initial_values: row.to_h,
            error: " Fecha: #{row["date"]} no encontrada."
          }
          next
        end

        if !SubmarketWeek.find_by(week_id: week_id, submarket_id: submarket_id).nil?
          errors << {
            initial_values: row.to_h,
            error: "El registro ya existe."
          }
          next
        end

        submarket_weeks << {
          week_id: week_id,
          submarket_id: submarket_id
        }
      end

      if errors.empty?
        SubmarketWeek.bulk_insert values: submarket_weeks
      else
        csv_with_errors(errors, ["date", "submarket_name", "errors"], "db/tmp_files/errores_submercado_temporadas.csv")
      end
    end

    private
      def csv_with_errors(list, attributes, file_path)

        CSV.open(file_path, "wb") do |csv|

          csv << attributes
          list.each do |data|
            csv << [data[:initial_values].values, data[:error]].flatten
          end
        end
        file_path
      end
  end

end
