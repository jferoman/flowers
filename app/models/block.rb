class Block < ApplicationRecord

  validates_uniqueness_of :name
  validates_presence_of   :name

  belongs_to :farm
  has_many :beds

end
