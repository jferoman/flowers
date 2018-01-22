class BlockProductionsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_block_production, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :new, :batch_delete, :edit]

  def index
    @block_productions = @farm.block_productions.includes(:variety, :week, :block)
    @origines = @block_productions.all.pluck(:origin).uniq
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
    if @block_production.destroy
      flash[:success] = 'Produccion por bloque eliminada.'
      redirect_to index_route
    else
      flash[:error] = @block_production.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @block_production.attributes = block_production_params
    if @block_production.save
      flash[:success] = 'Produccion por bloque actualizada.'
      redirect_to index_route
    else
      flash[:error] = @block_production.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def batch_delete
    if params[:block_production_id] == "all"
      BlockProduction.where(id: @farm.block_productions.pluck(:id) ).delete_all
      notice = "Todas las producciones por bloque fueron borradas."
    else
      BlockProduction.where(origin: params[:block_production_id]).delete_all
      notice = "Las producciones por bloque : #{params[:block_production_id].to_s}  fueron borradas."
    end
      redirect_to index_route, notice: notice
  end

  def import_block_productions
    begin
      file_path = BlockProduction.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to index_route, notice: "Produccion por bloques importadas correctamente"
      send_file file_path
    else
     redirect_to index_route, alert: "El archivo cargado contiene errores."
    end
  end

  private
  def block_production_params
    params.require(:block_production).permit(:quantity, :origin, :variety_id, :farm_id, :week_id, :block_id)
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
