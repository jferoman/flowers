class ModelSowingSolution < ApplicationRecord

  validates_presence_of :bed_number, :block_id, :bed_type_id

  belongs_to :block
  belongs_to :bed_type

end
