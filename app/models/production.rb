class Production < ApplicationRecord

  validates_presence_of :quantity, :origin
  validates :origin, uniqueness: { scope: [:variety_id, :cutting_id, :week_id] }

  belongs_to :variety
  belongs_to :week
  belongs_to :cutting
end
