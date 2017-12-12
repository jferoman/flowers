class Block < ApplicationRecord
  require 'csv'

  validates_presence_of :name, :farm_id

  validates :name, uniqueness: { scope: :farm_id }

  belongs_to :farm
  has_many :beds
  has_many :block_color_flowers
  has_many :sowing_solutions

  class << self
    def import file_path
      blocks = []

        CSV.foreach(file_path, {
          encoding: "iso-8859-1:utf-8",
          headers: true,
          converters: :all,
          header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|

          farm_id = (Farm.find_by(name: row["finca"].to_s).id rescue nil)
          next if farm_id.nil?

          blocks << {
            name: row["nombre"],
            farm_id: farm_id
          }
        end
        Block.bulk_insert values: blocks
    end
  end

end
