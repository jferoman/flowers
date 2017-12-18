class Bed < ApplicationRecord
  require 'csv'

  validates_presence_of :number, :total_area, :usable_area, :block_id, :bed_type_id

  validates_numericality_of :total_area, :allow_nil => false, :greater_than => 0.0
  validates_numericality_of :usable_area, :allow_nil => false, :greater_than => 0.0

  validates :number, uniqueness: { scope: :block_id }

  belongs_to :block
  belongs_to :bed_type
  has_many :sowing_details
  has_many :bed_productions

  class << self
    def import file_path
      beds = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          block_id = (Block.find_by(name: row["block_name"].to_s).id rescue nil)

          if block_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Bloque #{row["block_name"]} no encontrado."
            }
            next
          end

          bed_type_id = (BedType.find_by(width: row["bed_type_width"].to_s).id rescue nil)

          if bed_type_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Ancho del tipo de cama: #{row["bed_type_width"]} no encontrado."
            }
            next
          end

          bed = Bed.find_by(number: row["bed_number"], block_id: block_id)
          if !bed.nil?
            errors << {
              initial_values: row.to_h,
              error: "Cama numero #{row["bed_number"]} y bloque: #{row["block_name"]} ya existe"
            }
            next
          end

          beds << {
            number: row["bed_number"],
            total_area: row["total_area"],
            usable_area: row["usable_area"],
            block_id: block_id,
            bed_type_id: bed_type_id
          }
        end

        if errors.empty?
          Bed.bulk_insert values: beds
        else
          csv_with_errors errors
        end
    end

    private
      def csv_with_errors beds_list
        attributes = %w{bed_number block_name total_area usable_area bed_type_width errores}
        file_path = "db/tmp_files/errores_camas.csv"

        CSV.open(file_path, "wb") do |csv|

          csv << attributes
          beds_list.each do |data|
            csv << [data[:initial_values].values, data[:error]].flatten
          end
        end
        file_path
      end
  end

end
