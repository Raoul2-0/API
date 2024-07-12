FactoryBot.define do
    # Define a factory for the classroom model
    factory :classroom do
      # Use faker to generate random data for the attributes
      number_of_students { Faker::Number.between(from: 0, to: 50) }
      # Use associations to create related objects
      #association :class_level
      association :local
      #association :cycle
      # Add any other attributes or associations that you need
    end
  end
  