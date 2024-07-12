# if ENV.fetch('REDIS_URL')
#   # Heroku/amazon will use a max of size number of connections to push jobs to Redis 
#   Sidekiq.configure_server do |config|
#     config.redis = { url: ENV.fetch('REDIS_URL'), size: 12, network_timeout: 30 }
#   end

#   Sidekiq.configure_client do |config|
#     config.redis = { url: ENV.fetch('REDIS_URL'), size: 12, network_timeout: 30 }
#   end
# end