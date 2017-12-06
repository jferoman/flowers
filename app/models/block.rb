class Block < ApplicationRecord

  validates_presence_of :name, :farm_id

  validates :name, uniqueness: { scope: :farm_id }

  belongs_to :farm
  has_many :beds
  has_many :block_color_flowers
  has_many :model_sowing_solutions

end
