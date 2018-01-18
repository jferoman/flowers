class BedProductionsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_bed_production, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :new, :batch_delete, :edit]

  def index
    @bed_productions = @farm.bed_productions.includes(:variety, :week, :bed)
    @statuses = @bed_productions.all.pluck(:status).uniq
  end

  def new
    @bed_production = BedProduction.new
  end

  def create
    @new_bed_production = BedProduction.new(bed_production_params)

    if @new_bed_production.save
      flash[:success] = 'Produccion por cama creada.'
      redirect_to index_route
    else
      flash[:error] = @new_bed_production.errors.full_messages.to_sentence
      redirect_to :new_bed_production
    end
  end

  def destroy
    if @bed_production.destroy
      flash[:success] = 'Produccion por cama eliminada.'
      redirect_to index_route
    else
      flash[:error] = @bed_production.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @bed_production.attributes = bed_production_params
    if @bed_production.save
      flash[:success] = 'Produccion por cama actualizada.'
      redirect_to index_route
    else
      flash[:error] = @bed_production.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def batch_delete
    if params[:bed_production_id] == "all"
      BedProduction.where(id: @farm.bed_productions.pluck(:id) ).delete_all
      notice = "Todas las producciones por cama fueron borradas."
    else
      BedProduction.where(status: params[:bed_production_id]).delete_all
      notice = "Las producciones por cama : #{params[:bed_production_id].to_s}  fueron borradas."
    end
      redirect_to index_route, notice: notice
  end

  def import_bed_productions
    begin
      file_path = BedProduction.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to index_route, notice: "Produccion por camas importadas correctamente"
      send_file file_path
    else
     redirect_to index_route, alert: "El archivo cargado contiene errores."
    end
  end

  private
  def bed_production_params
    params.require(:bed_production).permit(:quantity, :status, :variety_id, :week_id, :bed_id)
  end

  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

  def index_route
    "/farms/" + session[:farm_id].to_s + "/bed_productions"
  end

  def find_bed_production
    @bed_production = BedProduction.find(params[:id])
  end

end
