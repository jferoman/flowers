class ColorsController < ApplicationController
  
  before_action :authorize
  before_action :find_color, only: [:destroy, :edit, :update]

  def index
  	@colors = Color.all
  end

  def new
    @color = Color.new
  end

  def create
    new_color = Color.new({name: color_params})

    if new_color.save
      flash[:success] = 'Color creado'
      redirect_to colors_path
    else
      flash[:error] = new_color.errors.full_messages.to_sentence
      redirect_to :new_color
    end
  end

  def destroy
    if @color.destroy
      flash[:success] = 'Color eliminado'
      redirect_to colors_path
    else
      flash[:error] = @color.errors.full_messages.to_sentence
      redirect_to colors_path
    end
  end
  
  def edit

  end

  def update
    @color.attributes = {name: color_params}
    if @color.save
      flash[:success] = 'Color actualizado'
      redirect_to colors_path
    else
      flash[:error] = @color.errors.full_messages.to_sentence
      redirect_to colors_path
    end
  end

  def csv_import
    begin
      Color.import(params[:file].path)
      redirect_to colors_path, notice: "Bloques importados corretamente"
    rescue
     redirect_to colors_path, alert: "El archivo cargado contiene errores."
    end
  end

  private

  def color_params
    params['color'].require(:name)
  end

  def find_color
    @color = Color.find(params[:id])
  end
end
