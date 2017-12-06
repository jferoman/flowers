class Cutting < ApplicationRecord

  validates_presence_of :farm_id, :week_id, :variety_id, :status
  validates_numericality_of :quantity, :allow_nil => false, :greater_than => 0.0

  belongs_to :farm
  belongs_to :week
  belongs_to :variety

end
