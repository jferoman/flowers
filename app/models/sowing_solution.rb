class SowingSolution < ApplicationRecord
  validates_presence_of :week_id, :block_id, :bed_type_id, :variety_id

  belongs_to :variety
  belongs_to :week
  belongs_to :block
  belongs_to :bed_type
  belongs_to :expiration_week, :class_name => 'Week'

end
