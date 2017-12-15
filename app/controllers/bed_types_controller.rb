class BedTypesController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_bed_type, only: [:destroy, :edit, :update]

  def index
    @bed_types = BedType.all
  end

  def new
    @bed_type = BedType.new
  end

  def create
    @new_bed_type = BedType.new(bed_type_params)

    if @new_bed_type.save
      flash[:success] = 'Tipos de cama creado'
      redirect_to bed_types_path
    else
      flash[:error] = @new_bed_type.errors.full_messages.to_sentence
      redirect_to :new_bed_type
    end
  end

  def destroy
    if @bed_type.destroy
      flash[:success] = 'Tipos de cama eliminado'
      redirect_to bed_types_path
    else
      flash[:error] = @bed_type.errors.full_messages.to_sentence
      redirect_to bed_types_path
    end
  end

  def edit

  end

  def update
    @bed_type.attributes = bed_type_params
    if @bed_type.save
      flash[:success] = 'Tipos de cama actualizado'
      redirect_to bed_types_path
    else
      flash[:error] = @bed_type.errors.full_messages.to_sentence
      redirect_to bed_types_path
    end
  end

  private
  def bed_type_params
    params.require(:bed_type).permit(:name, :width)
  end

  def find_bed_type
    @bed_type = BedType.find(params[:id])
  end

end
