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

  resources :company do
    resources :farms
    resources :markets, :demands, only: [:index, :create, :new, :edit, :destroy, :update]
  end

  resources :farms do
    resources :flower_densities, :cuttings, :blocks, :coldrooms, :block_color_flowers, :sowing_details, only: [:index, :create, :new, :edit, :destroy, :update]
  end

  resources :coldrooms, :blocks, :beds, only: [:create, :new, :edit, :destroy, :update]
  resources :colors, :storage_resistance_types, :varieties, :storage_resistances, only: [:index, :create, :show, :new, :edit, :destroy, :update]
  resources :weeks, :beds, :flower_densities, :submarkets, :markets, :cuttings, :demands, :color_submarkets, :bed_types, :block_color_flowers, :sowing_details

  resources :blocks do
    resources :beds, only: [:index, :create, :new, :edit, :destroy, :update]
  end

  post '/company/:company_id/farms/:farm_id/import_blocks' => 'blocks#import_blocks'
  post '/colors/csv_import' => 'colors#csv_import'
  post '/varieties/csv_import' => 'varieties#csv_import'
  post '/storage_resistances/csv_import' => 'storage_resistances#csv_import'
  post 'farms/:farm_id/import_blocks' => 'blocks#import_blocks'
  post '/beds/import_beds' => 'beds#import'
  post '/import_weeks' => 'weeks#import_weeks'
  post '/import_submarkets' => 'submarkets#import'
  post 'farms/:farm_id/import_cuttings' => 'cuttings#import_cuttings'
  post '/import_color_submarkets' => 'color_submarkets#import'
  post '/import_submarket_weeks' => 'submarkets#import_submarket_weeks'
  post '/import_demands' => 'demands#import_demands'
  post 'farms/:farm_id/import_block_color_flowers' => 'block_color_flowers#import'
  post 'farms/:farm_id/import_sowing_details' => 'sowing_details#import'

end
