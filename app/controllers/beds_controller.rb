class BedsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_bed, only: [:destroy, :edit, :update]
  before_action :find_block, only: [:create]


  def index
    if params[:block_id].present?
      @beds = Block.find(params[:block_id]).beds
    else
      @beds = Farm.find(session[:farm_id]).beds
    end
  end

  def new
    @bed = Bed.new
  end

  def create
    binding.pry
    @new_bed = @block.beds.new(bed_params)

    if @new_bed.save
      flash[:success] = 'Tipos de cama creado'
      redirect_to block_beds_path
    else
      flash[:error] = @new_bed.errors.full_messages.to_sentence
      redirect_to :new_bed
    end
  end

  def destroy
    if @bed.destroy
      flash[:success] = 'Tipos de cama eliminado'
      redirect_to beds_path
    else
      flash[:error] = @bed.errors.full_messages.to_sentence
      redirect_to beds_path
    end
  end

  def edit
  end

  def update
  end

  def import_beds
    begin
      bed.import(params[:file].path)
      redirect_to beds_path, notice: "Tipos de camas importados corretamente"
    rescue
     redirect_to beds_path, alert: "El archivo cargado contiene errores."
    end
  end

  private
    def bed_params
      params.require(:bed).permit(:number, :total_area, :usable_area, :block_id, :bed_type_id)
    end

    def find_bed
      @bed = Bed.find(params[:id])
    end

    def find_block
    binding.pry

      @block = Block.find(params[:block_id])
    end

end
