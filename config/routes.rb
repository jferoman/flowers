Rails.application.routes.draw do

  get 'sowing_graph/index'

  #get 'main_reports/index'
  #get '/home' => 'main_reports#index'

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

  post '/sessions_controller/change_farm' => 'sessions#change_farm'

  resources :company do
    resources :farms
    resources :markets, :demands, only: [:index, :create, :new, :edit, :destroy, :update]
  end


  resources :farms do
    resources :flower_densities,
              :cuttings,
              :blocks,
              :coldrooms,
              :block_color_flowers,
              :sowing_details,
              :productivity_curves,
              :block_productions,
              :bed_productions,
              :sowing_solutions,
              only: [:index, :create, :new, :edit, :destroy, :update]
    resources :main_reports, :sowing_graphs, :productions, only: [:index]
    # get "/farm_sowing/" => "main_reports#sowing" , as: :main_reports_sowing
    # get "/farm_production/" => "main_reports#production" , as: :main_reports_production

  end

  resources :coldrooms, :blocks, :beds, only: [:create, :new, :edit, :destroy, :update]
  resources :flowers, :colors, :storage_resistance_types, :varieties, :storage_resistances, only: [:index, :create, :show, :new, :edit, :destroy, :update]
  resources :weeks,
            :beds,
            :flower_densities,
            :submarkets,
            :markets,
            :cuttings,
            :demands,
            :color_submarkets,
            :bed_types,
            :block_color_flowers,
            :sowing_details,
            :productivity_curves,
            :submarket_weeks,
            :sowing_solutions,
            :block_productions,
            :bed_productions


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
  post '/import_submarket_week' => 'submarket_week#import'
  post 'farms/:farm_id/import_cuttings' => 'cuttings#import_cuttings'
  post '/import_color_submarkets' => 'color_submarkets#import'
  post '/import_submarket_weeks' => 'submarket_weeks#import'
  post '/company/:company_id/import_demands' => 'demands#import_demands'
  post '/farms/:farm_id/import_productivity_curves' => 'productivity_curves#csv_import'
  post 'farms/:farm_id/import_block_color_flowers' => 'block_color_flowers#import'
  post 'farms/:farm_id/import_sowing_details' => 'sowing_details#import'
  post 'farms/:farm_id/import_sowing_solutions' => 'sowing_solutions#import'
  post 'farms/:farm_id/import_block_productions' => 'block_productions#import_block_productions'
  post 'farms/:farm_id/import_bed_productions' => 'bed_productions#import_bed_productions'

  delete '/farms/:farm_id/productivity_curves' => 'productivity_curves#destroy'
  delete '/farms/:farm_id/block_color_flowers' => 'block_color_flowers#batch_delete', as: :block_color_flowers_batch_delete
  delete '/farms/:farm_id/sowing_details' => 'sowing_details#batch_delete', as: :sowing_details_batch_delete
  delete '/farms/:farm_id/sowing_solutions' => 'sowing_solutions#batch_delete', as: :sowing_solutions_batch_delete
  delete '/beds' => 'beds#batch_delete', as: :beds_batch_delete
  delete '/demands' => 'demands#batch_delete', as: :demands_batch_delete
  delete '/color_submarkets' => 'color_submarkets#batch_delete', as: :color_submarkets_batch_delete
  delete '/weeks' => 'weeks#batch_delete', as: :weeks_batch_delete
  delete '/submarket_weeks' => 'submarket_weeks#batch_delete', as: :submarket_weeks_batch_delete
  delete '/farms/:farm_id/block_productions' => 'block_productions#batch_delete', as: :block_productions_batch_delete
  delete '/farms/:farm_id/bed_productions' => 'bed_productions#batch_delete', as: :bed_productions_batch_delete
  delete '/farms/:farm_id/cuttings' => 'cuttings#batch_delete', as: :cuttings_batch_delete

end
