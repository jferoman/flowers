class Variety < ApplicationRecord
  require 'csv'

  validates_presence_of  :participation, :storage_resistance_type_id, :flower_id, :color_id, :name
  validates_inclusion_of :participation, :in => 0.0..1.0
  validates :flower_id, uniqueness: { scope: :name }

  belongs_to :storage_resistance_type
  belongs_to :flower
  belongs_to :color

  has_many :productivity_curves
  has_many :cuttings
  has_many :sowing_details
  has_many :sowing_solutions
  has_many :block_productions
  has_many :bed_productions
  has_many :productions

  delegate :name, to: :flower, prefix: true
  delegate :name, to: :color, prefix: true
  delegate :name, to: :storage_resistance_type, prefix: true


  class << self
    def import file_path
      attributes = %w(name resistance_to_storage_name flower_name participation color_name)
      varieties = []
      errors = []

      CSV.foreach(file_path, {
        encoding: "iso-8859-1:utf-8",
        headers: true,
        converters: :all,
        skip_lines: /^(?:,\s*)+$/,
        header_converters: lambda {|h| h.downcase.gsub(' ','_') }}) do |row|

        varieties << row.to_h.slice(*attributes)
      end

      varieties.each do |variety|

        flower = Flower.find_by(name: I18n.transliterate(variety['flower_name']).upcase)
        storage_resistance_type = StorageResistanceType.find_by(name: I18n.transliterate(variety['resistance_to_storage_name']).upcase)
        color = Color.find_by(name: I18n.transliterate(variety['color_name']).upcase)

        if flower.nil? or storage_resistance_type.nil?
          errors << variety
        else
          variety.except!('resistance_to_storage_name','flower_name')
          variety.merge!(storage_resistance_type_id: storage_resistance_type.id, flower_id: flower.id, color_id: color.id )
        end
      end

      Variety.bulk_insert values: varieties
    end
  end

  ##
  # Return the productivity for this variety in a especific week.
  # Paramter: week, Number of the week to get the value or prductivity.
  # Return the valur of th productivity in the week.
  ##
  def get_productivity week
    productivity_curves.find_by(week_number: week).production
  end


end
