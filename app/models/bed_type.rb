class BedType < ApplicationRecord

  validates_presence_of :name, :width
  validates :name, uniqueness: { scope: :width }

  has_many :beds
  has_many :sowing_solutions

end
