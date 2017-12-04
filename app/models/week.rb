class Week < ApplicationRecord

  has_many :submarket_weeks
  has_many :demands, througth:
  has_many :cuttings, througth:

end
