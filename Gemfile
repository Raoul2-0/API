source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'
#gem 'sass-rails', require: false
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use i18n to internationalize the rails application
gem 'rails-i18n', '~> 6.0.0'
# Use globalize for backend internationalization 
gem 'globalize', '~> 6.0.1'
# Add role to user model
gem 'rolify', '~> 5.2' # https://github.com/RolifyCommunity/rolify
# Manage role associated to each user
gem 'pundit', '~> 2.2.0' # https://github.com/varvet/pundit
# generation of serializers
gem 'active_model_serializers', '~> 0.10.12'
# Simulate MTI multi table inheritance
gem 'active_record-acts_as', '~> 5.0.3'
#Manage user authentication
gem 'devise', '~> 4.7', '>= 4.7.1'
# devise-jwt for token-based authentication with Devise
gem 'devise-jwt', '~> 0.10.0'

gem 'rollbar'
# gem for getting countries, regions and cities
gem 'countries'# , '~> 3.0'
# gem for gettting cities
#gem 'city-state'
gem 'cities'#, '~> 0.3.1'
#gem 'geocoder'

#gem 'country_state_select'
#gem 'geokit'
# gem 'mimemagic', '~> 0.3.5'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'

# This gem is useful for handling pagination
gem 'kaminari', '~> 1.2.1'
#  Use jwt for user login sign up and authorizing/authenticating with JWT
#gem 'jwt', '~> 2.3.0'

# 
#gem 'sidekiq', '~> 6.2', '>= 6.2.2'
 
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# enable AWS
#gem 'aws-sdk-s3', require: false

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 0.4.1'

# Image analysis and transformations often require the image_processing gem
# gem "image_processing", ">= 1.2"

# To avoid polling for changes (Windows error)
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

# Humanise attribute
gem "human_attributes", '~> 0.7.0'

# Validate jsonb attributes
gem 'has_defaults', '~> 1.1.1'
gem 'json-schema', '~> 3.0.0'

# To set environment variables
gem 'dotenv-rails', '~> 2.7.6'
# Validate global attributes

#gem 'globalize-validations', '~> 1.0.0'



group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'bullet' #  It will watch your queries while you develop and notify you when you should add eager loading to avoid N+1 queries
  # debugger
  gem 'pry-byebug', '~> 3.9.0'
  # Generate an Entity Relation diagram PDF file, based on the current database schema
  gem 'rails-erd', require: false
end

group :test do
  # Usefull for to perform testing
  gem 'rspec-rails', ">= 3.10.0"
  # Complementary gem to rspec to shorten matchers
  gem 'shoulda-matchers', '~> 5.0'
  # Create fixture for testing purpose
  gem 'factory_bot_rails', '~> 6.2.0'
  # Create fake data to feed factory_bot_rails
  gem 'faker', '~> 2.19.0'
  #checking the test coverage of the project
  gem 'simplecov', require: false

end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 3.0.0'
  gem 'brakeman'
  gem 'rubocop', '~> 1.18.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rswag-api'
gem 'rswag-ui'