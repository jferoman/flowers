class ProductivityCurve < ApplicationRecord

  validates_presence_of :week_number, :cost, :production, :cut
  validates_numericality_of :cost,:production, :cut, :allow_nil => false, :greater_than => 0
  validates :week_number, uniqueness: { scope: :farm_id, :variety_id }

  belongs_to :farm
  belongs_to :variety
end
