class ColorSubmarket < ApplicationRecord

  validates_presence_of :price, :default

  belongs_to :color
  belongs_to :submarket

end
