class Variety < ApplicationRecord

  belongs_to :storage_resistance_type
  belongs_to :flower
  belongs_to :color
  has_many :productivity_curves
  has_many :cuttings
  has_many :sowing_details

end
