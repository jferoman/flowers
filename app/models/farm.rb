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
  def sowing_detail_qty_by_date( variety_id = nil, block_id = nil, color_id = nil, origin = "Ejecutado")

    sowing = sowing_details.where(origin: origin)

    sowing_by_variety = sowing_detail_by_variety(variety_id, origin)
    sowing_by_block   = sowing_detail_by_block(block_id, origin)
    sowing_by_color   = sowing_detail_by_color(color_id , origin)

    sowing = sowing.merge(sowing_by_variety) unless sowing_by_variety.empty?
    sowing = sowing.merge(sowing_by_block) unless sowing_by_block.empty?
    sowing = sowing.merge(sowing_by_color) unless sowing_by_color.empty?
    sowing.group(:week_id).sum(:quantity).transform_keys{ |key| Week.find(key).initial_day }.sort.to_h
  end

  ##
  # Retorna las siembras de la finca por variedad y origen
  # Parametros: Id de la variedad para las siembras
  #            origen: Por defecto lo hace para los Ejecutados
  # Retorna: planos de siembra para el origen dado y la variedad especificada
  #
  ##
  def sowing_detail_by_variety( variety_id = nil, origin = "Ejecutado")
    sowing_details.where(origin: origin, variety_id: variety_id)
  end

  ##
  # Retorna las siembras de la finca por bloque y origen
  # Parametros: Id del bloque para las siembras
  #             origen: Por defecto lo hace para los Ejecutados
  # Retorna: planos de siembra para el origen dado y el bloque especificada
  #
  ##
  def sowing_detail_by_block( block_id = nil, origin = "Ejecutado")
    sowing_details.where(origin: origin).joins(:bed).where(:beds => {block_id: block_id})
  end

  ##
  # Retorna las siembras de la finca por color y origen
  # Parametros: Id del color para las siembras
  #             origen: Por defecto lo hace para los Ejecutados
  # Retorna: planos de siembra para el origen dado y el color especificado
  #
  ##
  def sowing_detail_by_color( color_id = nil, origin = "Ejecutado")
    sowing_details.where(origin: origin).joins(:variety).where(:varieties => {color_id: color_id})
  end

  ##
  # Retorna la cantidad de esquejes por fecha.
  # Parametros: origen: Por defecto lo hace para los Ejecutados
  # Retorna: Hash con la fecha y la cantidad de siembras.
  ##
  def cuttings_by_date where
    cuttings.where(where).group(:week_id).sum(:quantity).transform_keys{ |key| Week.find(key).initial_day }.sort.to_h
  end

  ##
  # Retorna los bloques de la finca que tienen siembras ejecutadas
  # Parametros: origen: Por defecto lo hace para los Ejecutados
  # Retorna: bloques
  ##
  def blocks_sowed origin = "Ejecutado"
    Block.where(id: beds.where(id: sowing_details.where(origin: origin).pluck(:bed_id)).pluck(:block_id).uniq)
  end

end
