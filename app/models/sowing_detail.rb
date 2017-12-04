class SowingDetail < ApplicationRecord

  belongs_to :variety
  belongs_to :week
  belongs_to :bed

end
