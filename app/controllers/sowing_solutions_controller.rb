class SowingSolutionsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_sowing_solution, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :new, :edit, :batch_delete]

  def index
    @sowing_solutions = @farm.sowing_solutions.includes(:variety, :week, :block, :bed_type)
  end

  def new
    @sowing_solution = SowingSolution.new
  end

  def create
    @new_sowing_solution = SowingSolution.new(sowing_solution_params)

    if @new_sowing_solution.save
      flash[:success] = 'Detalle de siembra creado'
      redirect_to index_route
    else
      flash[:error] = @new_sowing_solution.errors.full_messages.to_sentence
      redirect_to :new_sowing_solution
    end
  end

  def destroy
    if @sowing_solution.destroy
      flash[:success] = 'Detalle de siembra eliminado.'
      redirect_to index_route
    else
      flash[:error] = @sowing_solution.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @sowing_solution.attributes = sowing_solution_params

    if @sowing_solution.save
      flash[:success] = 'Detalle de siembra actualizado'
      redirect_to index_route
    else
      flash[:error] = @sowing_solution.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def import
    begin
      file_path = SowingSolution.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to index_route, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to index_route, notice: "Detalle de siembra importado correctamente."
    end
  end

  private
    def sowing_solution_params
      params["sowing_solution"]["expiration_week_id"]= Week.find(params["sowing_solution"]["week_id"].to_i).next_week_in(params["sowing_solution"]["cutting_week"].to_i).id
      params.require(:sowing_solution).permit(:quantity, :cutting_week, :variety_id, :week_id, :block_id, :bed_type_id, :expiration_week_id)
    end

    def find_sowing_solution
      @sowing_solution = SowingSolution.find(params[:id])
    end

    def find_farm
      @farm = Farm.find(session[:farm_id])
    end

    def index_route
      "/farms/" + session[:farm_id].to_s + "/sowing_solutions"
    end
end
