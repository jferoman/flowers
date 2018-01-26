class ProductionsController < ApplicationController
  before_action :find_farm, only: [:index]

  def index
    gon.bed_prod = []

    @selected_variety ||= params["variety_id"]
    @selected_color  ||= params["color_id"]
    @selected_block  ||= params["block_id"]

    @blocks = @farm.blocks_sowed
    gon.bed_prod = @farm.bed_productions_qty_by_week(params["variety_id"], params["block_id"], params["color_id"], origin = "Ejecutado")
  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

end
