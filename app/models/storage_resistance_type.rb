class StorageResistanceType < ApplicationRecord

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :storage_resistance
  has_many :variety

end
