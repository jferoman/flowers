require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Angle
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # setup bower components folder for lookup
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    # fonts
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    # images
    config.assets.precompile << /\.(?:png|jpg)$/
    # precompile vendor assets
    config.assets.precompile += %w( base.js )
    config.assets.precompile += %w( base.css )
    # precompile themes
    config.assets.precompile += [
                                 'angle/themes/theme-a.css',
                                 'angle/themes/theme-b.css',
                                 'angle/themes/theme-c.css',
                                 'angle/themes/theme-d.css',
                                 'angle/themes/theme-e.css',
                                 'angle/themes/theme-f.css',
                                 'angle/themes/theme-g.css',
                                 'angle/themes/theme-h.css'
                                ]
    # Controller assets
    config.assets.precompile += [
                                 # Scripts
                                 'main_reports.js',
                                 'users.js',
                                 'blocks.js',
                                 'coldrooms.js',
                                 'varieties.js',
                                 'colors.js',
                                 'bed_types.js',
                                 'beds.js',
                                 'weeks.js',
                                 'storage_resistances.js',
                                 'storage_resistance_types.js',
                                 'flower_densities.js',
                                 'flowers.js',
                                 'submarkets.js',
                                 'markets.js',
                                 'cuttings.js',
                                 'color_submarkets.js',
                                 'demands.js',
                                 'productivity_curves.js',
                                 'block_color_flowers.js',
                                 'sowing_details.js',
                                 'submarket_weeks.js',
                                 'sowing_solutions.js',
                                 'block_productions.js',
                                 'bed_productions.js',
                                 'sowings.js',
                                 'productions.js',
                                 'land_uses.js',
                                 'farm_productions.js',
                                 # 'Styles',
                                 'main_reports.css',
                                 'blocks.css',
                                 'users.css',
                                 'coldrooms.css',
                                 'varieties.css',
                                 'colors.css',
                                 'bed_types.css',
                                 'beds.css',
                                 'weeks.css',
                                 'storage_resistances.css',
                                 'storage_resistance_types.css',
                                 'flower_densities.css',
                                 'flowers.css',
                                 'submarkets.css',
                                 'markets.css',
                                 'cuttings.css',
                                 'color_submarkets.css',
                                 'demands.css',
                                 'block_color_flowers.css',
                                 'sowing_details.css',
                                 'productivity_curves.css',
                                 'block_color_flowers.css',
                                 'submarket_weeks.css',
                                 'sowing_solutions.css',
                                 'block_productions.css',
                                 'bed_productions.css',
                                 'sowings.css',
                                 'productions.css',
                                 'land_uses.css',
                                 'farm_productions.css'
                                ]
  end
end


