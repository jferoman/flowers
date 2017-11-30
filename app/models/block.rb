class Block < ApplicationRecord

  validates_uniqueness_of :name
  validates_presence_of   :name, :area
  validates_numericality_of :area, :allow_nil => false, :greater_than => 0.0

  belongs_to :land
  has_many :beds

end
