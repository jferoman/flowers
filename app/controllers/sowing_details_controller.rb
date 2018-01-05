class SowingDetailsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_sowing_detail, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :new, :edit]

  def index
  end

  def new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private
    def sowing_detail_params
      params.require(:sowing_detail).permit(:usage, :block_id, :flower_id, :color_id)
    end

    def find_sowing_detail
      @sowing_detail = SowingDetail.find(params[:id])
    end

    def find_farm
      @farm = Farm.find(session[:farm_id])
    end

    def index_route
      "/farms/" + session[:farm_id].to_s + "/sowing_details"
    end
end
