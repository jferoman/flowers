class UsersController < ApplicationController
	layout 'pages'

	def new
  end

  def create
		user = User.new(user_params)
		if user.save
			session[:user_id] = user.id
      session[:farm_id] = user.default_farm
      session[:company_id] = Farm.find(user.default_farm).company.id
			redirect_to '/home'
		else
			redirect_to '/signup'
		end
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :default_farm)
	end

end
