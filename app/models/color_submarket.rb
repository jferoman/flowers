class ColorSubmarket < ApplicationRecord

  validates_presence_of :price
  validates :default, inclusion: { in: [ true, false ] }
  validates :color_id, uniqueness: { scope: :submarket_id }

  belongs_to :color
  belongs_to :submarket

  class << self
    def import file_path
      color_submarkets = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          color_id = (Color.find_by(name: row["color"].to_s).id rescue nil)
          if color_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Color #{row["color"]} no encontrado."
            }
            next
          end

          submarket_id = (Submarket.find_by(code: row["market_code"]).id rescue nil)
          if submarket_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Submercado #{row["market_code"]} no encontrado."
            }
            next
          end

          color_submarkets << {
            price: row["price"],
            default: (row["default"] == 1 ? true : false),
            submarket_id: submarket_id,
            color_id: color_id
          }
        end

        if errors.empty?
          ColorSubmarket.bulk_insert values: color_submarkets
        else
          csv_with_errors errors
        end
    end

    private
      def csv_with_errors color_submarket_list
        attributes = %w{market_code color price default errorres}
        file_path = "db/tmp_files/errores_color_submercados.csv"

        CSV.open(file_path, "wb") do |csv|

          csv << attributes
          color_submarket_list.each do |data|
            csv << [data[:initial_values].values, data[:error]].flatten
          end
        end
        file_path
      end
  end
end
