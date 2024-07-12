FactoryBot.define do
  factory :evaluation do

    evaluation_date { Date.today }
    #start_time { Time.now }
    #end_time { Time.now + 1.hour }

    association :course
    association :local
    
  end
end
