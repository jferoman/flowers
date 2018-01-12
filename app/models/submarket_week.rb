class SubmarketWeek < ApplicationRecord
  validates_presence_of :week_id, :submarket_id
  validates :week_id, uniqueness: {scope: :submarket_id}
  belongs_to :week
  belongs_to :submarket

  class << self
    def import file_path
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
