require 'faker'
require 'factory_bot_rails'

module ClassroomHelpers
   def classroom_parameters
    {
        number_of_students: Faker::Number.digit,
        local: create_local,
        #cycle_id: cycle_id,
        #specialty_id: specialty_id,
        #class_level_id: class_level_id
    }
   end
 
  def create_classroom
    handle_monitoring(FactoryBot.create(:classroom, classroom_parameters))
  end
  
  def build_classroom
    FactoryBot.build(:classroom, classroom_parameters)
  end
  
end