class Variety < ApplicationRecord

  belongs_to :storage_resistance_type
  belongs_to :flower
  has_one :color
  has_many :productivity_curves
  has_many :cuttings, through: :cuttings_varieties

end
