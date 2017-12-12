class ColdroomsController < ApplicationController
  before_action :authorize, :lock_farms_per_company
  before_action :find_coldroom, only: [:destroy, :edit, :update]

  def index
    @cold_rooms = find_farm.
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
  def coldroom_params
    params[:coldroom]["farm_id"] = find_farm.id
    params.require(:coldroom).permit(:name, :capacity, :farm_id)
  end

  def find_farm
    farm = Farm.find(session[:farm_id])
  end

  def index_route
    "/company/" + session[:company_id].to_s + "/farms/" + session[:farm_id].to_s + "/coldrooms"
  end

  def find_coldroom
    @coldroom = Coldroom.find(params[:id])
  end
end
