class Color < ApplicationRecord

  validates_presence_of   :name
  validates_uniqueness_of :name

  has_many :demands
  has_many :varieties
  has_many :block_color_flowers
  has_many :color_submarkets
end
