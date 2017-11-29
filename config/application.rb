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
    config.assets.precompile += ['angle/themes/theme-a.css',
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
                                 'users.js',
                                 'charts.js',
                                 'dashboard.js',
                                 'documentation.js',
                                 'elements.js',
                                 'extras.js',
                                 'forms.js',
                                 'maps.js',
                                 'multilevel.js',
                                 'pages.js',
                                 'tables.js',
                                 'widgets.js',
                                 'blog.js',
                                 'ecommerce.js',
                                 'forum.js',
                                 'time_tables.js',
                                 'commercial_matrices.js',
                                 'dead_matrices.js',
                                 'reference_fleets.js',
                                 'iph_dates.js',
                                 'calendars.js',
                                 # Stylesheets
                                 'charts.css',
                                 'dashboard.css',
                                 'documentation.css',
                                 'elements.css',
                                 'extras.css',
                                 'forms.css',
                                 'maps.css',
                                 'multilevel.css',
                                 'pages.css',
                                 'tables.css',
                                 'widgets.css',
                                 'blog.css',
                                 'ecommerce.css',
                                 'forum.css',
                                 'time_tables.css',
                                 'commercial_matrices.css',
                                 'dead_matrices.css',
                                 'reference_fleets.css',
                                 'iph_dates.css',
                                 'calendars.css',
                                ]


  end

end


