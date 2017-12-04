class Company < ApplicationRecord

  validates_uniqueness_of :name, :nit
  validates_presence_of   :name, :nit

  has_many :farms

end
