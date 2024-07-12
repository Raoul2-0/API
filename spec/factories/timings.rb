FactoryBot.define do
    factory :timing do
      start_time { Faker::Time.forward(days: 23, period: :morning) }
      end_time { Faker::Time.forward(days: 23, period: :evening) }
    end
  end
  