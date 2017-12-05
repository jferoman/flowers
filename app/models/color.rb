class Color < ApplicationRecord
  has_many :demands
  has_many :varieties
  has_many :block_colors_flowers
  has_many :color_submarkets
end
