class Week < ApplicationRecord

  validates_presence_of :initial_day, :week
  validates :initial_day, uniqueness: { scope: :week }

  has_many :submarket_weeks
  has_many :cuttings
  has_many :demands
  has_many :sowing_details

end
