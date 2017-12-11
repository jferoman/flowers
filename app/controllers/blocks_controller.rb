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
      redirect_to "/company/" + session[:company_id].to_s + "/farms/" + session[:farm_id].to_s + "/blocks"
    else
      flash[:error] = new_block.errors.full_messages.to_sentence
      redirect_to :new_block
    end
  end


  def destroy

  end

  def update

  end

  def block_params
    params[:block]["farm_id"] = find_farm.id
    params.require(:block).permit(:name , :farm_id)
  end

  def find_farm
    farm = Farm.find(session[:farm_id])
  end

end
