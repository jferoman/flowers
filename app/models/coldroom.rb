class Coldroom < ApplicationRecord

  validates_presence_of :name, :farm_id, :capacity
  validates_numericality_of :capacity, :allow_nil => false, :greater_than => 0

  belongs_to :farm
end
