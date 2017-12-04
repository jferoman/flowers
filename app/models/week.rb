class Week < ApplicationRecord

  has_many :submarket_weeks
  has_many :cuttings, through: :cuttings_weeks
  has_many :demands, througth: :demands_weeks

end
