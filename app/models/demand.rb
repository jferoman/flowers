class Demand < ApplicationRecord

  belongs_to :company
  belongs_to :color
  belongs_to :flower
  belongs_to :martket
end
