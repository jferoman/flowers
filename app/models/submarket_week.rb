class SubmarketWeek < ApplicationRecord
  validates_presence_of :week_id, :submarket_id
  validates :week_id, uniqueness: {scope: :submarket_id}
  belongs_to :week
  belongs_to :submarket
end
