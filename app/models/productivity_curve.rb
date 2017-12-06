class ProductivityCurve < ApplicationRecord

  validates_presence_of :week_number, :cost, :production, :cut, :farm_id, :variety_id
  validates_numericality_of :cost, :allow_nil => false, :greater_than => 0.0
  validates_numericality_of :production, :cut, :allow_nil => false, :greater_than => 0
  validates :week_number, uniqueness: { scope: [:farm_id, :variety_id] }

  belongs_to :farm
  belongs_to :variety
end
