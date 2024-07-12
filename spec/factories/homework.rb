
FactoryBot.define do
    factory :homework do
        denomination { Faker::Lorem.word }
        description { Faker::Lorem.paragraph }
        optional { "false" }
        due_date {Faker::Date.in_date_period(year: 2024, month: 6)}
        homeworkable_type { "Course" }
        homeworkable_id { 1 }
        association :serve 
        
    end
  end