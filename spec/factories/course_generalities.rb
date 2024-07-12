FactoryBot.define do
    factory :course_generality do
      # attributs de course_generality ici
        denomination { Faker::Lorem.word }
        description { Faker::Lorem.paragraph }
        duration { Faker::Lorem.word }
    end
  end
  