class Bed < ApplicationRecord

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

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          block_id = (Block.find_by(name: row["block_name"].to_s).id rescue nil)
          bed_type_id = (BedType.find_by(width: row["bed_type_width"].to_s).id rescue nil)

          beds << {
            number: row["bed_number"],
            total_area: row["total_area"],
            usable_area: row["usable_area"],
            block_id: block_id,
            bed_type_id: bed_type_id
          }
        end
        Bed.bulk_insert values: beds
    end
  end

end
