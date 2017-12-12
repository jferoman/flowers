class Coldroom < ApplicationRecord

  validates_presence_of :name, :farm_id, :capacity
  validates_numericality_of :capacity, :allow_nil => false, :greater_than => 0

  validates :name, uniqueness: { scope: :farm_id }

  belongs_to :farm
end
