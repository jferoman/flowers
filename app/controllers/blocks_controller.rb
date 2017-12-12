class BlocksController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_block, only: [:destroy, :edit, :update]

  def index
    @blocks = find_farm.blocks
  end

  def new
    @block = Block.new
  end

  def create
    new_block = Block.new block_params

    if new_block.save
      flash[:success] = 'Bloque creado'
      redirect_to index_route
    else
      flash[:error] = new_block.errors.full_messages.to_sentence
      redirect_to :new_block
    end
  end

  def destroy
    if @block.destroy
      flash[:success] = 'Bloque eliminado'
      redirect_to index_route
    else
      flash[:error] = @block.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit

  end

  def update
    @block.attributes = block_params
    if @block.save
      flash[:success] = 'Bloque actualizado'
      redirect_to index_route
    else
      flash[:error] = @block.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def import_blocks
    begin
      Block.import(params[:file].path)
      redirect_to company_farm_blocks_path, notice: "Bloques importados corretamente"
    rescue
     redirect_to company_farm_blocks_path, alert: "El archivo cargado contiene errores."
    end
  end

  private
  def block_params
    params[:block]["farm_id"] = find_farm.id
    params.require(:block).permit(:name, :capacity, :farm_id)
  end

  def find_farm
    farm = Farm.find(session[:farm_id])
  end

  def index_route
    "/company/" + session[:company_id].to_s + "/farms/" + session[:farm_id].to_s + "/coldrooms"
  end

  def find_block
    @block = Block.find(params[:id])
  end

end
