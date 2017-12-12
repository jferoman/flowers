Rails.application.routes.draw do

  get 'colors/index'

  get 'varieties/index'

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

  resources :company do
    resources :farms 
  end

  resources :coldrooms, only: [:create, :new, :edit, :destroy, :update]
  resources :storage_resistance_types, only: [:create, :show, :new, :edit, :destroy, :update]
  resources :colors, :varieties, :storage_resistances, only: [:index, :create, :show, :new, :edit, :destroy, :update]
  resources :blocks, only: [:create, :new, :edit, :destroy, :update]

  post '/company/:company_id/farms/:farm_id/import_blocks' => 'blocks#import_blocks'
  post '/colors/csv_import' => 'colors#csv_import'
  post '/storage_resistances/csv_import' => 'storage_resistances#csv_import'
  post 'farms/:farm_id/import_blocks' => 'blocks#import_blocks'
 
  resources :farms do
    resources :blocks, only: [:index, :create, :new, :edit, :destroy, :update]
    resources :coldrooms, only: [:index, :create, :new, :edit, :destroy, :update]
  end
end
