# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins '*'
#     resource '*', 
#         #headers: :any,
#         headers: %w(Authorization),
#         expose: %w(Authorization),
#         methods: [:get, :post, :patch, :put, :options]
#   end
# end