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
