class BedProduction < ApplicationRecord

  validates_presence_of :quantity, :status
  validates :status, uniqueness: { scope: [:variety_id, :bed_id, :week_id] }

  belongs_to :variety
  belongs_to :bed
  belongs_to :week
end
