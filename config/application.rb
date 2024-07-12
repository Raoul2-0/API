require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"
# Load environment variable in .env
require 'dotenv/load'
# require 'dotenv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ELearningApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # Set internationalization
    config.i18n.available_locales = [:en, :fr, :it]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true

    # handle belongs to association 
    config.active_record.belongs_to_required_by_default = true

    # Sidekid configuration queues
    #config.active_job.queue_adapter = :sidekiq
    # Handling errors on authorization
    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden
    # load modules from the lib directory
    config.eager_load_paths += %W(#{config.root}/lib)

    # load nested local modules
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    
    Rails.application.routes.default_url_options[:host] = ENV.fetch('ELEARNING_API_HOST')
    
    # replace test_unit with rspec when running scalford
    config.generators do |g|
      g.test_framework :rspec
    end
    #config.cache_store = :memory_store
    config.cache_store = :file_store, "#{Rails.root}/cache"

    # load the all the permissions in the permissions variable
    #config.permissions = Dir[Rails.root.join('config', 'permissions', '**', '*.yml')].map { |file| YAML.load_file(file) }.reduce({}, :merge)

    # resources that can be constantized
    ALLOWED_CLASSES = Dir[Rails.root.join('app', 'models', '*.rb')].map do |file|
      model_name = File.basename(file, '.rb').classify
      model_name unless model_name == 'ApplicationRecord'
    end.compact.freeze
    



    # #if Rails.env.staging? Rails.env.staging? or Rails.env.production?
    # ActionMailer::Base.smtp_settings = {
    #   :address        => 'smtp.socketlabs.com',
    #   :port           => '25',
    #   :user_name      => ENV.fetch('SOCKETLABS_USERNAME'),
    #   :password       => ENV.fetch('SOCKETLABS_PASSWORD'),
    #   :authentication => :login,
    #   :domain         => ENV.fetch('DOMAIN'),
    #   :enable_starttls_auto => true
    # }
    # #end

    #To send an email add the following configuration
    #config.action_mailer.raise_delivery_errors = true
    #config.action_mailer.perform_deliveries = true
    #onfig.action_mailer.delivery_method = :smtp
    #config.action_mailer.default_url_options = { host:  ENV.fetch('MAIL_HOST') }
    # config.action_mailer.smtp_settings = {
    #   user_name:      ENV.fetch('SOCKETLABS_USERNAME'),
    #   password:       ENV.fetch('SOCKETLABS_PASSWORD'),
    #   domain:         ENV.fetch('DOMAIN'),
    #   address:       'smtp.socketlabs.com',
    #   port:          '587',
    #   authentication: :login,
    #   enable_starttls_auto: true
    # }

  end
end
