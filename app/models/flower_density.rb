class FlowerDensity < ApplicationRecord

  validates_numericality_of :density, :allow_nil => false, :greater_than => 0.0
  validates :farm_id, uniqueness: { scope: :flower_id }

  belongs_to :farm
  belongs_to :flower

end
