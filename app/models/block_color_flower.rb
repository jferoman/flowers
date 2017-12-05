class BlockColorFlower < ApplicationRecord
  belongs_to :block
  belongs_to :flower
  belongs_to :color
end
