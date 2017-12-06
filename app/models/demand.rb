class Demand < ApplicationRecord

  validates_numericality_of :quantity, :allow_nil => false, :greater_than => 0
  validates_presence_of :color_id, :flower_id, :market_id, :week_id

  belongs_to :color
  belongs_to :flower
  belongs_to :market
  belongs_to :week

end
