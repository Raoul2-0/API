FactoryBot.define do
    # Define a factory for the scholastic_period model
    factory :scholastic_period do
      # Use faker to generate random data for the attributes
      #name { Faker::Date.between(from: 2.years.ago, to: Date.today).year.to_s + "-" + Faker::Date.between(from: Date.today, to: 2.years.from_now).year.to_s }
      #start_date { Faker::Date.between(from: 2.years.ago, to: Date.today) }
      #end_date { Faker::Date.between(from: Date.today, to: 2.years.from_now) }
      # Add any other attributes or associations that you need
    end
  end
  