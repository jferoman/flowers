class CuttingsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_cutting, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create]

  def index
    @cuttings = @farm.cuttings
  end

  def new
    @cutting = Cutting.new
  end

  def create
    @new_cutting = @farm.cuttings.new(cutting_params)

    if @new_cutting.save
      flash[:success] = 'Bloque creado'
      redirect_to index_route
    else
      flash[:error] = @new_cutting.errors.full_messages.to_sentence
      redirect_to :new_cutting
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def cutting_params
    params.require(:cutting).permit(:quantity, :status, :farm_id ,:week_id, :variety_id)
  end

  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

  def index_route
    "/farms/" + session[:farm_id].to_s + "/cuttings"
  end

  def find_cutting
    @cutting = Cutting.find(params[:id])
  end

end
