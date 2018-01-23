class Farm < ApplicationRecord

  validates_uniqueness_of :code, :name
  validates_presence_of   :code, :name, :company_id
  validates_length_of :code, minimum: 2, on: :create

  belongs_to :company
  has_many :blocks
  has_many :productivity_curves
  has_many :flower_densities
  has_many :block_productions
  has_many :cuttings
  has_many :coldrooms

  has_many :beds, through: :blocks
  has_many :block_color_flowers, through: :blocks
  has_many :sowing_details, through: :beds
  has_many :sowing_solutions, through: :blocks
  has_many :bed_productions, through: :beds
  has_many :block_productions, through: :blocks

  def productivity_curves_varieties
    Variety.where(id: productivity_curves.all.pluck(:variety_id).uniq)
  end

  ##
  # Retorna la fecha del ultimo plano de siembra ejecutado para la finca
  ##
  def last_sowing_detail
    Week.where(id: sowing_details.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).last.initial_day rescue "-"
  end

  ##
  # Retorna la fecha de la última producción ejecutado para la finca
  ##
  def last_bed_production
    Week.where(id: bed_productions.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).last.initial_day rescue "-"
  end

  ##
  # Retorna la fecha del último esqueje ejecutado para la finca
  ##
  def last_cutting
    Week.where(id: cuttings.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).last.initial_day rescue "-"
  end

  ##
  # Retorna la cantidad de siembras por fecha
  # Parametros: origen: Por defecto lo hace para los Ejecutados
  # Retorna: Hash con la fecha y la cantidad de siembras.
  ##
  def sowing_detail_by_date (origin = "Ejecutado")
    sowing_details.where(origin: origin).group(:week_id).sum(:quantity).transform_keys{ |key| Week.find(key).initial_day }.sort.to_h
  end

end
