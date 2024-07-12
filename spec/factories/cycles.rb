FactoryBot.define do
    # Define a factory for the cycle model
    factory :cycle do
      # Use associations to create related objects
      association :scholastic_period
      # Add any other attributes or associations that you need
    end
  end
  