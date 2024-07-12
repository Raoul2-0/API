FactoryBot.define do
    # Define a factory for the local model
    factory :local do
      # Use faker to generate random data for the attributes
      capacity { Faker::Number.between(from: 10, to: 50) }
      localisation { Faker::Address.full_address }
      # Add any other attributes or associations that you need
    end
  end
  