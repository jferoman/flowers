source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.0.rc1'

# HEROKU doesn't support sqlite3.
# Comment this gem
#gem 'sqlite3'
# and uncomment the following
 gem 'pg'
# gem 'thin'
ruby '2.4.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'activerecord-import', '~> 0.18.2'
gem 'gon'
gem 'rails_handsontable'
#Multiple inserts
gem 'bulk_insert'
# Use unicorn as the app server
# gem 'unicorn'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "bower-rails", "~> 0.9.2"
#Deplyment to production GEMS
group :development do
	gem 'capistrano', '~> 3.8', '>= 3.8.1'
	gem 'capistrano-rails', '~> 1.2', '>= 1.2.3'
	gem 'capistrano-passenger', '~> 0.2.0'
	gem 'capistrano-rbenv', '~> 2.1'
	gem 'capistrano-bower'
	gem 'capistrano-rails-db'
	gem 'better_errors'


end

group :test,:development do
	gem 'binding_of_caller'
	gem 'factory_girl_rails'
	gem 'database_cleaner'
	gem 'rspec-rails'
	gem 'pry'
end
