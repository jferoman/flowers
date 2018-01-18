class BlockProductionsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_block_production, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create]

  def index
    @block_productions = @farm.block_productions.includes(:variety, :week, :block)
    @statuses = @block_productions.all.pluck(:status).uniq
  end

  def new
    @block_production = BlockProduction.new
  end

  def create
    @new_block_production = @farm.block_productions.new(block_production_params)

    if @new_block_production.save
      flash[:success] = 'Produccion por Bloque creado'
      redirect_to index_route
    else
      flash[:error] = @new_block_production.errors.full_messages.to_sentence
      redirect_to :new_block_production
    end
  end

  def destroy
    if @block_prodcution.destroy
      flash[:success] = 'Produccion por bloque eliminada.'
      redirect_to index_route
    else
      flash[:error] = @block_prodcution.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @block_prodcution.attributes = block_prodcution_params
    if @block_prodcution.save
      flash[:success] = 'Produccion por bloque actualizada.'
      redirect_to index_route
    else
      flash[:error] = @block_prodcution.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def import_block_productions
    begin
      BlockProduction.import(params[:file].path)
      redirect_to farm_blocks_path, notice: "Produccion por bloques importadas correctamente"
    rescue
     redirect_to farm_blocks_path, alert: "El archivo cargado contiene errores."
    end
  end

  private
  def block_production_params
    params.require(:block_production).permit(:quantity, :status, :variety_id, :farm_id, :week_id, :block_id)
  end

  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

  def index_route
    "/farms/" + session[:farm_id].to_s + "/block_productions"
  end

  def find_block_production
    @block_production = BlockProduction.find(params[:id])
  end
end
