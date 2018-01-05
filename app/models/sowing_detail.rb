class SowingDetail < ApplicationRecord

  validates_presence_of :quantity, :cutting_week
  validates_numericality_of :quantity, :allow_nil => false, :greater_than => 0.0

  belongs_to :variety
  belongs_to :week
  belongs_to :bed

  class << self

    def import file_path
      sowing_details = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          bed_id = (Block.find_by(name: row["block_name"].to_s.upcase).beds.find_by(number: row["bed_number"].to_s).id rescue nil)
          if bed_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Cama #{row["bed_number"]} no encontrado."
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

          week_id = (Week.find_by(initial_day: row["sowing_date"]).id rescue nil)
          if week_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Fecha: #{row["sowing_date"]} no encontrada."
            }
            next
          end

          sowing_detail = SowingDetail.find_by(variety_id: variety_id, week_id: week_id, bed_id: bed_id)
          if !sowing_detail.nil?
            errors << {
              initial_values: row.to_h,
              error: "El resgsitro #{row["variety_name"]}, #{row["bed_number"]}, #{row["block_name"]} #{row["sowing_date"]} ya existe."
            }
            next
          end

          sowing_details << {
            quantity: row["quantity"],
            cutting_week: row["cutting_week"],
            bed_id: bed_id,
            variety_id: variety_id,
            week_id: week_id
          }
        end

        if errors.empty?
          SowingDetail.bulk_insert values: sowing_details
        else
          csv_with_errors errors
        end
    end

    private
      def csv_with_errors sowing_detail_list

        attributes = %w{block_name bed_number sowing_date variaty_name quantity cutting_week errores}
        file_path = "db/tmp_files/errores_detalle_siembra.csv"

        CSV.open(file_path, "wb") do |csv|

          csv << attributes
          sowing_detail_list.each do |data|
            csv << [data[:initial_values].values, data[:error]].flatten
          end
        end
        file_path
      end
  end
end
