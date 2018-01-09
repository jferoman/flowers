module BlockColorFlowersHelper
  def get_blocks
    Block.where(id: @block_color_flowers.pluck(:block_id).uniq)
  end
end
