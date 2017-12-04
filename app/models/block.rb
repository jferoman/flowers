class Block < ApplicationRecord

  validates_uniqueness_of :name
  validates_presence_of   :name

  belongs_to :farm
  has_many :beds
  has_many :block_color_flowers

end
