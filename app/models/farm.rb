class Farm < ApplicationRecord

  validates_uniqueness_of :code
  validates_presence_of   :code
  validates_length_of :code, minimum: 2, on: :create

  belongs_to :company
  has_many :blocks

end
