class BlockColorFlower < ApplicationRecord

  validates :usage, inclusion: { in: [ true, false ] }
  validates :block_id, uniqueness: { scope: [:flower_id, :color_id] }

  belongs_to :block
  belongs_to :flower
  belongs_to :color
end
