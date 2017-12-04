class Market < ApplicationRecord
  has_many :demands
  has_many :submarkets
end
