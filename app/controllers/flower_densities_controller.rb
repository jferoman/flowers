class FlowerDensitiesController < ApplicationController
  before_action :authorize, :lock_farms_per_company
  before_action :find_flower_density, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create]

  def index
    @flower_densities = @farm.flower_densities
  end

  def new
    @flower_density = FlowerDensity.new
  end

  def create
    @new_flower_density = @farm.flower_densities.new(flower_density_params)

    if @new_flower_density.save
      flash[:success] = 'Densidad creada'
      redirect_to index_route
    else
      flash[:error] = @new_flower_density.errors.full_messages.to_sentence
      redirect_to :new_flower_density
    end
  end

  def destroy
    if @flower_density.destroy
      flash[:success] = 'Densidad eliminada'
      redirect_to index_route
    else
      flash[:error] = @flower_density.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @flower_density.attributes = flower_density_params
    if @flower_density.save
      flash[:success] = 'Densidad de flor actualizada'
      redirect_to index_route
    else
      flash[:error] = @flower_density.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  private
  def flower_density_params

    params.require(:flower_density).permit(:flower_id, :density, :farm_id)
  end

  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

  def index_route
    "/farms/" + session[:farm_id].to_s + "/flower_densities"
  end

  def find_flower_density
    @flower_density = FlowerDensity.find(params[:id])
  end
end
