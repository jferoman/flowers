class Demand < ApplicationRecord

  belongs_to :company
  belongs_to :color
  belongs_to :flower
  belongs_to :martket
  has_many :weeks, through: :demands_weeks

end
