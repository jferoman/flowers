class DemandsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_demand, only: [:destroy, :edit, :update]
  before_action :find_company, only: [:index, :new, :create, :edit]

  def index
    @demands = @company.demands
  end

  def new
    @demand = Demand.new
  end

  def create
    @new_demand = @company.demands.new(demand_params)

    if @new_demand.save
      flash[:success] = 'Demanda creada'
      redirect_to index_route
    else
      flash[:error] = @new_demand.errors.full_messages.to_sentence
      redirect_to :new_demand
    end
  end

  def destroy
    if @demand.destroy
      flash[:success] = 'Demanda eliminada'
      redirect_to index_route
    else
      flash[:error] = @demand.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @demand.attributes = demand_params
    if @demand.save
      flash[:success] = 'Demanda actualizado'
      redirect_to index_route
    else
      flash[:error] = @demand.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def import_demands
    begin
      file_path = Demand.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to demands_path, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to demands_path, notice: "Demanda importadas correctamente."
    end
  end

  private
  def demand_params
    params.require(:demand).permit(:quantity, :color_id, :market_id, :flower_id, :week_id)
  end

  def find_demand
    @demand = Demand.find(params[:id])
  end

  def find_company
    @company = Company.find(session[:company_id])
  end

  def index_route
    "/company/" + session[:company_id].to_s + "/demands"
  end
end
