class StorageResistance < ApplicationRecord

  validates_presence_of  :week_number, :storage_resistance_type_id, :lost_percentage

  validates_inclusion_of :lost_percentage, :in => 0.0..1.0
  belongs_to :storage_resistance_type
end
