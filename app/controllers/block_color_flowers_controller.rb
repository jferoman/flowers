class BlockColorFlowersController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_block_color_flower, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create, :new, :edit, :batch_delete]

  def index
    @block_color_flowers = @farm.block_color_flowers
  end

  def new
    @block_color_flower = BlockColorFlower.new
  end

  def create
    @new_block_color_flower = @farm.block_color_flowers.new(block_color_flower_params)
    if @new_block_color_flower.save
      flash[:success] = 'Uso de Bloque creado'
      redirect_to index_route
    else
      flash[:error] = @new_block_color_flower.errors.full_messages.to_sentence
      redirect_to :new_block_color_flower
    end
  end

  def destroy
    if @block_color_flower.destroy
      flash[:success] = 'Uso de bloque eliminado'
      redirect_to index_route
    else
      flash[:error] = @block_color_flower.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @block_color_flower.attributes = block_color_flower_params
    if @block_color_flower.save
      flash[:success] = 'Uso de bloque actualizado'
      redirect_to index_route
    else
      flash[:error] = @block_color_flower.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def import
    begin
      file_path = BlockColorFlower.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to index_route, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to index_route, notice: "Uso de bloques importados correctamente."
    end
  end

  def batch_delete
    if params[:block_id] == "all"
      BlockColorFlower.where(id: @farm.block_color_flowers.pluck(:id) ).delete_all
      notice = "Todas los usos de bloque fueron borrados"
    else
      BlockColorFlower.where(block_id: params[:block_id]).delete_all
      notice = "los usos de bloque del bloque: " + Block.find(params[:block_id]).name + " fueron borrados."
    end
      redirect_to index_route, notice: notice
  end

  private
    def block_color_flower_params
      params.require(:block_color_flower).permit(:usage, :block_id, :flower_id, :color_id)
    end

    def find_block_color_flower
      @block_color_flower = BlockColorFlower.find(params[:id])
    end

    def find_farm
      @farm = Farm.find(session[:farm_id])
    end

    def index_route
      "/farms/" + session[:farm_id].to_s + "/block_color_flowers"
    end
end
