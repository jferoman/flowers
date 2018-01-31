class CuttingsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_cutting, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :batch_delete]

  def index
    @cuttings = @farm.cuttings
    @origins = @cuttings.pluck(:origin).uniq
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
    @cutting.attributes = cutting_params
    if @cutting.save
      flash[:success] = 'Corte actualizado'
      redirect_to index_route
    else
      flash[:error] = @cutting.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def destroy
    if @cutting.destroy
      flash[:success] = 'Corte eliminado'
      redirect_to index_route
    else
      flash[:error] = @cutting.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def batch_delete
    if params[:origin] == "all"
      Cutting.where(id: @farm.cuttings.pluck(:id) ).delete_all
      notice = "Todas los esquejes fueron borradas."
    else
      Cutting.where(origin: params[:origin]).delete_all
      notice = "Llos esquejes : #{params[:origin].to_s}  fueron borrados."
    end
      redirect_to index_route, notice: notice
  end

  def import_cuttings
    begin
      file_path = Cutting.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to farm_cuttings_path, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to farm_cuttings_path, notice: "Cortes importados correctamente."
    end

  end

  private
  def cutting_params
    params.require(:cutting).permit(:quantity, :origin, :farm_id ,:week_id, :variety_id, :cutting_week)
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
