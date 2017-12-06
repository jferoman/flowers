class SowingDetail < ApplicationRecord

  validates_presence_of :quantity
  validates_numericality_of :quantity, :allow_nil => false, :greater_than => 0.0

  belongs_to :variety
  belongs_to :week
  belongs_to :bed

end
