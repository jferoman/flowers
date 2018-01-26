class SowingDetailsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_sowing_detail, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :new, :edit, :batch_delete]

  def index
    @sowing_details = @farm.sowing_details.includes(:bed, :week, :variety, :expiration_week)
  end

  def new
    @sowing_detail = SowingDetail.new
  end

  def create
    @new_sowing_detail = SowingDetail.new(sowing_detail_params)

    if @new_sowing_detail.save
      flash[:success] = 'Detalle de siembra creado'
      redirect_to index_route
    else
      flash[:error] = @new_sowing_detail.errors.full_messages.to_sentence
      redirect_to :new_sowing_detail
    end
  end

  def destroy
    if @sowing_detail.destroy
      flash[:success] = 'Detalle de siembra eliminado.'
      redirect_to index_route
    else
      flash[:error] = @sowing_detail.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @sowing_detail.attributes = sowing_detail_params

    if @sowing_detail.save
      flash[:success] = 'Detalle de siembra actualizado'
      redirect_to index_route
    else
      flash[:error] = @sowing_detail.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def import
    begin
      file_path = SowingDetail.import(params[:file].path)
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

  def batch_delete
    if params[:variety_id] == "all"
      SowingDetail.where(id: @farm.sowing_details.pluck(:id) ).delete_all
      notice = "Todas los detalles de siembra fueron borrados"
    else
      SowingDetail.where(variety_id: params[:variety_id]).delete_all
      notice = "Los detalles de siembra de la variedad: " + Variety.find(params[:variety_id]).name + " fueron borrados."
    end
      redirect_to index_route, notice: notice
  end

  private
    def sowing_detail_params
      params["sowing_detail"]["expiration_week_id"]= Week.find(params["sowing_detail"]["week_id"].to_i).next_week_in(params["sowing_detail"]["cutting_week"].to_i).id
      params.require(:sowing_detail).permit(:quantity, :cutting_week, :origin, :variety_id, :week_id, :bed_id, :expiration_week_id)
    end

    def find_sowing_detail
      @sowing_detail = SowingDetail.find(params[:id])
    end

    def find_farm
      @farm = Farm.find(session[:farm_id])
    end

    def index_route
      "/farms/" + session[:farm_id].to_s + "/sowing_details"
    end
end
