FactoryBot.define do
    factory :report do
        denomination { Faker::Lorem.word }
        description { Faker::Lorem.paragraph }
    end
  end
  