class Cutting < ApplicationRecord

  belongs_to :farm
  has_many :weeks, through: :cuttings_weeks
  has_many :variety, through: :cuttings_varieties

end
