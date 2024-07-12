require 'faker'
require 'factory_bot_rails'

module ScholasticPeriodHelpers
   def scholastic_period_parameters
    {
      denomination: Faker::Lorem.word,
      description: Faker::Lorem.paragraph        
    }
   end
 
  def create_scholastic_period
    handle_monitoring(FactoryBot.create(:scholastic_period, scholastic_period_parameters))
  end
  
  def build_scholastic_period
    FactoryBot.build(:scholastic_period, scholastic_period_parameters)
  end

  def scholastic_period_payload(scholastic_period, success=true)
    if success
      {
        denomination: scholastic_period.denomination,
        description: scholastic_period.description
      }
    end
  end
  
end