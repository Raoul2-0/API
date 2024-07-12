require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  config.cache_classes = false
  config.action_controller.perform_caching = ENV['CACHE_ENABLED']
  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end
  #config.cache_store = :file_store, "#{Rails.root}/cache", { expires_in: 2.minutes } # i have added this line
  config.cache_store = :file_store, "#{Rails.root}/cache", { expires_in: 1.hour } # i have added this line


  # Store uploaded files on the local file system (see config/storage.yml for options).
  # config.active_storage.service = :local 
  config.active_storage.service = ENV.fetch('DEV_STORAGE')
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true


  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  #Rails.application.routes.default_url_options[:host] = ENV.fetch('ELEARNING_API_HOST')
  Rails.application.routes.default_url_options[:host] = "localhost:3033"


  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
  #To send an email add the following configuration
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.default_url_options = { host:  ENV.fetch('MAIL_HOST') }
  # config.action_mailer.smtp_settings = {
  #   user_name:      ENV.fetch('SOCKETLABS_USERNAME'),
  #   password:       ENV.fetch('SOCKETLABS_PASSWORD'),
  #   domain:         ENV.fetch('DOMAIN'),
  #   address:       'smtp.socketlabs.com',
  #   port:          '587',
  #   authentication: :login,
  #   enable_starttls_auto: true
  # }

  config.after_initialize do
    Bullet.enable = true
    Bullet.rails_logger = true # logs violations
    Bullet.add_footer = true # adds footer to view with violation
  end
end
