class Week < ApplicationRecord

  has_many :submarket_weeks
  has_many :cuttings
  has_many :demands
  has_many :sowing_details

end
