class FarmProductionsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_production, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :new, :batch_delete, :edit]

  def index
    @productions = @farm.productions.includes(:variety, :week)
  end

  def new
    @production = Production.new
  end

  def create
    @new_production = Production.new(production_params)

    if @new_production.save
      flash[:success] = 'Producción.'
      redirect_to index_route
    else
      flash[:error] = @new_production.errors.full_messages.to_sentence
      redirect_to :new_production
    end
  end

  def destroy
    if @production.destroy
      flash[:success] = 'Producción.'
      redirect_to index_route
    else
      flash[:error] = @production.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @production.attributes = production_params
    if @production.save
      flash[:success] = 'Producción actualizada.'
      redirect_to index_route
    else
      flash[:error] = @production.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def batch_delete
    if params[:production_id] == "all"
      Production.where(id: @farm.productions.pluck(:id) ).delete_all
      notice = "Todas las producciónes fueron borradas."
    else
      Production.where(origin: params[:production_id]).delete_all
      notice = "Las producciónes por cama : #{params[:production_id].to_s}  fueron borradas."
    end
      redirect_to index_route, notice: notice
  end

  def import_productions
    begin
      file_path = Production.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to index_route, notice: "Producción importadas correctamente"
      send_file file_path
    else
     redirect_to index_route, alert: "El archivo cargado contiene errores."
    end
  end

  private
  def production_params
    params.require(:production).permit(:quantity, :origin, :variety_id, :week_id, :cutting_id)
  end

  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

  def index_route
    "/farms/" + session[:farm_id].to_s + "/farm_productions"
  end

  def find_production
    @production = Production.find(params[:id])
  end
end
