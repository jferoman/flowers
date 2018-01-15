class BedsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_bed, only: [:destroy, :edit, :update]
  before_action :find_block, only: [:create]

  def index
    if params[:block_id].present?
      @beds = Block.find(params[:block_id]).beds.includes(:bed_type, :block)
    else
      @beds = Farm.find(session[:farm_id]).beds.includes(:bed_type, :block)
    end
  end

  def new
    @bed = Bed.new
    find_block
  end

  def create
    @new_bed = @block.beds.new(bed_params)

    if @new_bed.save
      flash[:success] = 'Tipos de cama creado'
      redirect_to block_beds_path(@block)
    else
      flash[:error] = @new_bed.errors.full_messages.to_sentence
      redirect_to :new_bed
    end
  end

  def destroy
    if @bed.destroy
      flash[:success] = 'Cama eliminada'
      redirect_to beds_path
    else
      flash[:error] = @bed.errors.full_messages.to_sentence
      redirect_to beds_path
    end
  end

  def edit
  end

  def update
    @bed.attributes = bed_params
    if @bed.save
      flash[:success] = 'Cama actualizada'
      redirect_to beds_path
    else
      flash[:error] = @bed.errors.full_messages.to_sentence
      redirect_to beds_path
    end
  end

  def import
    begin
      file_path = Bed.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to beds_path, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to beds_path, notice: "Tipos de camas importados corretamente"
    end
  end

  def batch_delete
    if params[:block_id] == "all"
        if params[:block] == "/"
          Bed.where(id: Farm.find(session[:farm_id]).beds.pluck(:id)).delete_all
        else
          Bed.where(block_id: params[:block]).delete_all
        end
        notice = "Todas las camas fueron borradas"
    else
      Bed.where(block_id: params[:block_id]).delete_all
      notice = "las Camas del bloque: " + Block.find(params[:block_id]).name + " fueron borradas."
    end
      redirect_to beds_path, notice: notice
  end

  private
    def bed_params
      params.require(:bed).permit(:number, :total_area, :usable_area, :block_id, :bed_type_id)
    end

    def find_bed
      @bed = Bed.find(params[:id])
    end

    def find_block
      @block = Block.find(params[:block_id])
    end

end
