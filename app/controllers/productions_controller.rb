class ProductionsController < ApplicationController
  before_action :find_farm, only: [:index]

  def index

    from = @farm.first_bed_production

    gon.weeks = Farm.week_year_hash(from, Date.today+1.years)

    gon.production = []
    gon.proy_production = []
    gon.cuttings_and_prod = []
    gon.fulfillment = []

    @selected_variety = params["variety_id"] ||= ""
    @selected_color   = params["color_id"] ||= ""
    @selected_block   = params["block_id"] ||= ""

    @blocks = @farm.blocks_sowed
    gon.production = @farm.bed_productions_qty_by_week(params["variety_id"],
                                                       params["block_id"],
                                                       params["color_id"],
                                                       "Ejecutada")

    gon.proy_production = @farm.bed_productions_qty_by_week(params["variety_id"],
                                                            params["block_id"],
                                                            params["color_id"],
                                                            "Esperada")

    if params["block_id"].empty?

      cuttings = @farm.production_by_date(params["variety_id"],
                                          params["block_id"],
                                          params["color_id"],
                                          "Teorico")

      e_cuttings = @farm.cuttings_by_date(params["variety_id"],
                                          params["color_id"],
                                          "Ejecutado")

      t_cuttigns = @farm.cuttings_by_date(params["variety_id"],
                                          params["color_id"],
                                          "Teorico")

    e_cuttings = e_cuttings.keep_if { |k, v| gon.weeks.key? k }
    t_cuttigns = e_cuttings.keep_if { |k, v| gon.weeks.key? k }

    gon.fulfillment = t_cuttigns.merge(e_cuttings){ |k, a_value, b_value| (1-((a_value.to_f-b_value.to_f).abs/a_value.to_f))*100 }
    # gon.cuttings_and_prod = gon.proy_production.merge(cuttings){ |k, a_value, b_value| a_value + b_value }
    # gon.cuttings_and_prod = gon.cuttings_and_prod.keep_if { |k, v| gon.weeks.key? k }
    gon.proy_production = gon.proy_production.keep_if { |k, v| gon.weeks.key? k }

    # @farm.last_bed_production("Esperada")
    # gon.cuttings_and_prod =
    end

    gon.production = gon.production.keep_if { |k, v| gon.weeks.key? k }

  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

end

