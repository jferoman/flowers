class Land < ApplicationRecord

  validates_uniqueness_of :code
  validates_presence_of   :code, :total_area
  validates_length_of :code, minimum: 2, on: :create
  validates_numericality_of :total_area, :allow_nil => false, :greater_than_or_equal_to => 0.0

  belongs_to :company
end
