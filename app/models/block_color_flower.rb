class BlockColorFlower < ApplicationRecord

  validates :usage, inclusion: { in: [ true, false ] }
  validates :block_id, uniqueness: { scope: [:flower_id, :color_id] }

  belongs_to :block
  belongs_to :flower
  belongs_to :color

  class << self
    def import file_path
      blocks_color_flowers = []
      errors = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          color_id = (Color.find_by(name: row["color"].to_s.upcase).id rescue nil)
          if color_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Color #{row["color"]} no encontrado."
            }
            next
          end

          flower_id = (Flower.find_by(name: row["flor"].to_s.upcase).id rescue nil)
          if flower_id.nil?
            errors << {
              initial_values: row.to_h,
              error: "Flor: #{row["flor"]} no encontrada."
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

          blocks_color_flower = BlockColorFlower.find_by(block_id: block_id, flower_id: flower_id, color_id: color_id)
          if !blocks_color_flower.nil?
            errors << {
              initial_values: row.to_h,
              error: "El resgsitro #{row["color"]}, #{row["flor"]}, #{row["bloque"]} ya existe."
            }
            next
          end

          blocks_color_flowers << {
            usage: (row["uso"] == 1 ? true : false),
            color_id: color_id,
            block_id: block_id,
            flower_id: flower_id
          }
        end

        if errors.empty?
          BlockColorFlower.bulk_insert values: blocks_color_flowers
        else
          csv_with_errors errors
        end
    end
  end
    private
    def csv_with_errors blocks_color_flowers_list

      attributes = %w{bloque color flor uso errores}
      file_path = "db/tmp_files/errores_uso_bloques.csv"

      CSV.open(file_path, "wb") do |csv|

        csv << attributes
        demands_list.each do |data|
          csv << [data[:initial_values].values, data[:error]].flatten
        end
      end
      file_path
    end
end
