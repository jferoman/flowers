class Submarket < ApplicationRecord

  validates_presence_of :name, :code
  validates_uniqueness_of :code

  belongs_to :market
  has_many :color_submarkets
  has_many :submarket_weeks
end
