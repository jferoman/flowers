class Farm < ApplicationRecord

  validates_uniqueness_of :code, :name
  validates_presence_of   :code, :name, :company_id
  validates_length_of :code, minimum: 2, on: :create

  belongs_to :company
  has_many :blocks
  has_many :productivity_curves
  has_many :flower_densities
  has_many :productions
  has_many :cuttings
  has_many :coldrooms

  has_many :beds, through: :blocks
  has_many :block_color_flowers, through: :blocks

  def productivity_curves_varieties
    Variety.where(id: productivity_curves.all.pluck(:variety_id).uniq)
  end

end
