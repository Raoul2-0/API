require 'faker'
require 'factory_bot_rails'

module LocalHelpers
   def local_parameters
    {
        capacity: Faker::Number.digit,
        localisation: Faker::Lorem.paragraph,
    }
   end
 
  def create_local
    handle_monitoring(FactoryBot.create(:local, local_parameters))
  end
  
  def build_local
    FactoryBot.build(:local, local_parameters)
  end
  
end