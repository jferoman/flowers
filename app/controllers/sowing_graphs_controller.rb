class SowingGraphsController < ApplicationController
  before_action :find_farm, only: [:index]

  def index
    gon.cutting = []
    gon.sowing = []
    gon.sowing = @farm.sowing_detail_qty_by_date( params["variety_id"], params["block_id"], params["color_id"], origin = "Ejecutado")
    gon.cutting = @farm.cuttings_by_date( params["variety_id"], params["color_id"], origin = "Teorico") unless !params["block_id"].nil?

    #Filters
    @selected_variety ||= params["variety_id"]
    @selected_color  ||= params["color_id"]
    @selected_block  ||= params["block_id"]

    @blocks = @farm.blocks_sowed
  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end
end
