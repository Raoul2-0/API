# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# config.action_mailer.raise_delivery_errors = true
# config.action_mailer.perform_deliveries = true
# config.action_mailer.delivery_method = :smtp
# config.action_mailer.default_url_options = { host:  ENV.fetch('MAIL_HOST') }
ActionMailer::Base.smtp_settings = {
  user_name:      ENV.fetch('SOCKETLABS_USERNAME'),
  password:       ENV.fetch('SOCKETLABS_PASSWORD'),
  domain:         ENV.fetch('DOMAIN'),
  address:       'smtp.socketlabs.com',
  port:          '587',
  authentication: :login,
  enable_starttls_auto: true
}
