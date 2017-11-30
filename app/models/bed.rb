class Bed < ApplicationRecord

  validates_uniqueness_of :number
  validates_presence_of   :number, :area, :type, :capacity

  validates_numericality_of :area, :allow_nil => false, :greater_than => 0.0
  validates_numericality_of :capacity, :allow_nil => false, :greater_than => 0

  belongs_to :block
end
