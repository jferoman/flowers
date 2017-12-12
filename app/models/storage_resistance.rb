class StorageResistance < ApplicationRecord
  require 'csv'

  validates_presence_of  :week_number, :storage_resistance_type_id, :lost_percentage
  validates_inclusion_of :lost_percentage, :in => 0.0..1.0
  belongs_to :storage_resistance_type


  class << self
    def import file_path
      attributes = %w(storage_resistance_type_name week_number lost_percentage)
      storage_resistances = []
   
      CSV.foreach(file_path, {
        encoding: "iso-8859-1:utf-8",
        headers: true,
        converters: :all,
        header_converters: lambda {|h| h.downcase.gsub(' ','_') }}) do |row|
        
        storage_resistances << row.to_h.slice(*attributes)
      end
     
      storage_resistances.each do |storage_resistance|
      	binding.pry
      	storage_resistance_type_id = StorageResistanceType.find_by(name: storage_resistance['storage_resistance_type_name'])
      	storage_resistance.slice!('week_number','lost_percentage').merge!({storage_resistance_type_id: storage_resistance_type_id})
      end

      StorageResistance.bulk_insert values: storage_resistances
    end
  end
  
end
