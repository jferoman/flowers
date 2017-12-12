class VarietiesController < ApplicationController
  def index
  	@varieties = Variety.all
  end
end
