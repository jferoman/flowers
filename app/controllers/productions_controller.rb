class ProductionsController < ApplicationController
  before_action :find_farm, only: [:index]

  def index

    from = @farm.first_bed_production > Date.parse(1.years.ago.strftime("%F")) ?
           @farm.first_bed_production : Date.parse(1.years.ago.strftime("%F"))

    gon.weeks = Farm.week_year_hash(from, Date.today+1.years)
    gon.production = []
    gon.proy_production = []
    gon.cuttings_and_prod = []

    @selected_variety ||= params["variety_id"]
    @selected_color   ||= params["color_id"]
    @selected_block   ||= params["block_id"]

    @blocks = @farm.blocks_sowed
    gon.production = @farm.bed_productions_qty_by_week(params["variety_id"],
                                                       params["block_id"],
                                                       params["color_id"],
                                                       origin = "Ejecutado")

    gon.proy_production = @farm.bed_productions_qty_by_week(params["variety_id"],
                                                            params["block_id"],
                                                            params["color_id"],
                                                            origin = "Esperada")

    cuttings = @farm.cuttings_by_date (variety_id = nil, block_id = nil, color_id = nil, origin = "Teorico")

    gon.cuttings_and_prod = gon.proy_production.merge(cuttings){ |k, a_value, b_value| a_value + b_value }

    gon.proy_production = gon.proy_production.keep_if { |k, v| gon.weeks.key? k }
    gon.production = gon.production.keep_if { |k, v| gon.weeks.key? k }
    gon.cuttings_and_prod = gon.cuttings_and_prod.keep_if { |k, v| gon.weeks.key? k }

  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

end

