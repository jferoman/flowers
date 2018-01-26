class Cutting < ApplicationRecord
  require 'csv'

  validates_presence_of :farm_id, :week_id, :variety_id, :origin
  validates_numericality_of :quantity, :allow_nil => false, :greater_than => 0.0

  belongs_to :farm
  belongs_to :week
  belongs_to :variety

  class << self
    def import file_path
      cuttings = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          farm_id = (Farm.find_by(name: row["farm_name"].to_s.upcase).id rescue nil)
          if farm_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Finca #{row["farm_name"]} no encontrada."
            }
            next
          end

          variety_id = (Variety.find_by(name: row["variety_name"].to_s.upcase).id rescue nil)
          if variety_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Variedad: #{row["variety_name"]} no encontrada."
            }
            next
          end

          week_id = (Week.find_by('week = ? AND extract(year  from initial_day) = ?',row["company_week"], row["year"]).id rescue nil)
          if week_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Semana: #{row["company_week"]} del año #{row["year"]} no encontrada."
            }
            next
          end

          cuttings << {
            quantity: row["cuttings"],
            origin: "Ejecutado",
            cutting_week:row["cutting_week"],
            farm_id: farm_id,
            week_id: week_id,
            variety_id: variety_id
          }
        end

        if errors.empty?
          Cutting.bulk_insert values: cuttings
        else
          csv_with_errors errors
        end
  end

    private
    def csv_with_errors cuttings_list
      attributes = %w{year  company_week  variety_name farm_name cuttings cutting_week errores}
      file_path = "db/tmp_files/errores_cortes.csv"

      CSV.open(file_path, "wb") do |csv|

        csv << attributes
        cuttings_list.each do |data|
          csv << [data[:initial_values].values, data[:error]].flatten
        end
      end
      file_path
    end
  end

end
