class Production < ApplicationRecord

  validates_presence_of :quantity
  validates :status, uniqueness: { scope: [:variety_id, :farm_id, :week_id] }

  belongs_to :variety
  belongs_to :farm
  belongs_to :week

end
