class BlockColorFlower < ApplicationRecord

  validates_presence_of :usage
  validates :block_id, uniqueness: { scope: [:flower_id, :color_id] }

  belongs_to :block
  belongs_to :flower
  belongs_to :color
end
