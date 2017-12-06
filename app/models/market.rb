class Market < ApplicationRecord

  validates_presence_of :name, :code
  validates_uniqueness_of :name

  belongs_to :company
  has_many :demands
  has_many :submarkets
end
