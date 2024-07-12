FactoryBot.define do
    # Define a factory for the course model
    factory :serve do
        association :school
        association :staff
        association :job
        is_school_admin {true}
        first_serving_date {Faker::Date.in_date_period(year: 2024, month: 6)}
    end
  end
  