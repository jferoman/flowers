class ColorSubmarket < ApplicationRecord

  validates_presence_of :price, :default
  validates :color_id, uniqueness: { scope: :submarket_id }

  belongs_to :color
  belongs_to :submarket

end
