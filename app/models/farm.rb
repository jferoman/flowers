class Farm < ApplicationRecord

  validates_uniqueness_of :code
  validates_presence_of   :code, :company_id
  validates_length_of :code, minimum: 2, on: :create

  belongs_to :company
  has_many :blocks
  has_many :productivity_curves
  has_many :flower_densities

end
