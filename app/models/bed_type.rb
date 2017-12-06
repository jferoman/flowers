class BedType < ApplicationRecord

  validates_presence_of :name, :width
  validates_uniqueness_of :name
  validates :name, uniqueness: { scope: :width }

  has_many :beds

end
