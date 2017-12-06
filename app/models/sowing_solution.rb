class SowingSolution < ApplicationRecord
  validates_presence_of :bed_number, :block_id, :bed_type_id, :variety_id

  belongs_to :block
  belongs_to :bed_type
  belongs_to :variety

end
