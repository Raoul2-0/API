FactoryBot.define do
    # Define a factory for the course model
    factory :course do
      association :classroom
      association :scholastic_period
    end
  end
  