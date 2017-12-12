class StorageResistance < ApplicationRecord
  require 'csv'

  validates_presence_of  :week_number, :storage_resistance_type_id, :lost_percentage
  validates_inclusion_of :lost_percentage, :in => 0.0..1.0
  belongs_to :storage_resistance_type
  delegate :name, to: :storage_resistance_type

  class << self
    def import file_path
      attributes = %w(storage_resistance_type_name week_number lost_percentage)
      storage_resistances = []
      errors = []
   
      CSV.foreach(file_path, {
        encoding: "iso-8859-1:utf-8",
        headers: true,
        converters: :all,
        skip_lines: /^(?:,\s*)+$/,
        header_converters: lambda {|h| h.downcase.gsub(' ','_') }}) do |row|
        
        storage_resistances << row.to_h.slice(*attributes)
      end
     
      storage_resistances.each do |storage_resistance|
        
        storage_resistance_type_name = I18n.transliterate(storage_resistance['storage_resistance_type_name']).upcase
      	storage_resistance_type = StorageResistanceType.find_by(name: storage_resistance_type_name)
        if storage_resistance_type.nil?
      	  errors << {name: storage_resistance['storage_resistance_type_name']}
        else
          storage_resistance.except!('storage_resistance_type_name')
          storage_resistance.merge!('storage_resistance_type_id' => storage_resistance_type.id)
        end
      end
      binding.pry
      StorageResistance.bulk_insert values: storage_resistances
    end
  end
  
end
