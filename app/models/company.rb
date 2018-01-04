class Company < ApplicationRecord

  validates_uniqueness_of :name, :nit
  validates_presence_of   :name, :nit

  has_many :farms
  has_many :markets

  has_many :submarkets, through: :markets
  has_many :color_submarkets, through: :markets
  has_many :demands, through: :markets
  has_many :blocks, through: :farms

end
