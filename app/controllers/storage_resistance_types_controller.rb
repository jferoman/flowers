class StorageResistanceTypesController < ApplicationController

  before_action :authorize
  before_action :find_storage_resistance_type, only: [:destroy, :edit, :update]

  def new
    @storage_resistance_type = StorageResistanceType.new
  end

  def create
    new_storage_resistance_type = StorageResistanceType.new({name: storage_resistance_type_params})

    if new_storage_resistance_type.save
      flash[:success] = 'storage_resistance_type creado'
      redirect_to storage_resistances_path
    else
      flash[:error] = new_storage_resistance_type.errors.full_messages.to_sentence
      redirect_to :new_storage_resistance
    end
  end

  def destroy
    if @storage_resistance_type.destroy
      flash[:success] = 'storage_resistance_type eliminado'
      redirect_to storage_resistances_path
    else
      flash[:error] = @storage_resistance_type.errors.full_messages.to_sentence
      redirect_to storage_resistances_path
    end
  end
  
  def edit

  end

  def update
    @storage_resistance_type.attributes = {name: storage_resistance_type_params}
    if @storage_resistance_type.save
      flash[:success] = 'Tipo de resistencia al guarde actualizado'
      redirect_to storage_resistances_path
    else
      flash[:error] = @storage_resistance_type.errors.full_messages.to_sentence
      redirect_to storage_resistances_path
    end
  end


  private

  def storage_resistance_type_params
     params['storage_resistance_type'].require('name')
  end

  def find_storage_resistance_type
    @storage_resistance_type = StorageResistanceType.find(params[:id])
  end

end
