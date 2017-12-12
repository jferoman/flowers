Rails.application.routes.draw do

  #get 'main_reports/index'
  get '/home' => 'main_reports#index'

  # defaults to home
  #root :to => redirect('/signup')

  # These routes will be for signup. The first renders a form in the browse, the second will
  # receive the form and create a user in our database using the data given to us by the user.
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  # these routes are for showing users a login form, logging them in, and logging them out.
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  resources :blocks, only: [:create, :new, :edit, :destroy, :update]
  resources :coldrooms, only: [:create, :new, :edit, :destroy, :update]

  resources :company do
    resources :farms do
    end
  end

  resources :farms do
    resources :blocks, only: [:index, :create, :new, :edit, :destroy, :update]
    resources :coldrooms, only: [:index, :create, :new, :edit, :destroy, :update]
  end

  post "/company/:company_id/farms/:farm_id/import_blocks" => "blocks#import_blocks"


end
