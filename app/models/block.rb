class Block < ApplicationRecord

  validates_uniqueness_of :name
  validates_presence_of   :name, :area
  validates_numericality_of :area, :allow_nil => false, :greater_than => 0.0
  validate :area_size, :on => :create

  belongs_to :land

  private
  def area_size
    if area > land.total_area
      errors.add(:area, "Area del bloque no puede superar el area de la finca")
  elsif area > land.get_free_area
      errors.add(:area, "Area del bloque es mayor al area disponible de la finca")
    end
  end

end
