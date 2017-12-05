class Variety < ApplicationRecord

  validates_presence_of  :participation, :storage_resistance_type_id, :flower_id, :color_id
  validates_inclusion_of :participation, :in => 0.0..1.0

  belongs_to :storage_resistance_type
  belongs_to :flower
  belongs_to :color
  has_many :productivity_curves
  has_many :cuttings
  has_many :sowing_details

end
