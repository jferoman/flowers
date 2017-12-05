class Cutting < ApplicationRecord

  belongs_to :farm
  belongs_to :weeks
  belongs_to :variety

end
