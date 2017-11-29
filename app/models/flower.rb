class Flower < ApplicationRecord

  validates_uniqueness_of :type
  validates_presence_of   :type

end
