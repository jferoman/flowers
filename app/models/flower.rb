class Flower < ApplicationRecord

  validates_uniqueness_of :name
  validates_presence_of   :name

  has_many :flower_densities
  has_many :demands
  has_many :varieties
  has_many :block_color_flowers

end
