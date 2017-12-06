class Bed < ApplicationRecord

  validates_presence_of :number, :total_area, :usable_area, :block_id

  validates_numericality_of :total_area, :allow_nil => false, :greater_than => 0.0
  validates_numericality_of :usable_area, :allow_nil => false, :greater_than => 0.0

  validates :number, uniqueness: { scope: :block_id }

  belongs_to :block
  belongs_to :bed_type
  has_many :sowing_details

end
