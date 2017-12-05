class Cutting < ApplicationRecord

  validates_numericality_of :quantity, :allow_nil => false, :greater_than => 0

  belongs_to :farm
  belongs_to :weeks
  belongs_to :variety

end
