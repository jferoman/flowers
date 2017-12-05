class Submarket < ApplicationRecord

  belongs_to :market
  has_many :color_submarkets
  has_many :submarket_weeks
end
