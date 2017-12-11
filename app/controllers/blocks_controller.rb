class BlocksController < ApplicationController

  before_action :authorize, :lock_farms_per_company

  def index
  end

  def new
  end

  def create
  end

  def destroy
  end

  def update
  end
end
