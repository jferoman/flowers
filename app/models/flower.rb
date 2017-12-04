class Flower < ApplicationRecord

  has_many :flower_densities
  has_many :demands
  has_many :varieties
  has_many :block_color_flowers

end
