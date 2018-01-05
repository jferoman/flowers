class SowingDetailsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_sowing_detail, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :new, :edit]

  def index
    @sowing_details = @farm.sowing_details
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

  private
    def sowing_detail_params
      params.require(:sowing_detail).permit(:quantity, :cutting_week, :variety_id, :week_id, :bed_id)
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
