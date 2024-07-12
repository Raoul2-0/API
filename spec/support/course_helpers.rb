require 'faker'
require 'factory_bot_rails'

module CourseHelpers
   def course_parameters(school)
    {
      denomination: Faker::Lorem.word,
      description: Faker::Lorem.paragraph,
      classroom_id: create_classroom.id,
      scholastic_period_id: create_scholastic_period.id,
      course_generality_id: create_course_generality.id
    }
   end
 
  def create_course(school=nil, user=nil)
    handle_monitoring(FactoryBot.create(:course, course_parameters(school)), "create", user)
  end
  
  def build_course(school=nil, user=nil)
    FactoryBot.build(:course, course_parameters(school))
  end

  def course_payload(course, school, scholastic_period_id, success=true)
    if success
      {
        denomination: course.denomination,
        description: course.description,
        classroom_id: course.classroom_id,
        scholastic_period_id: scholastic_period_id,
        course_generality_id: course.course_generality_id,
        school_id: school.id
      }
    end
  end
  
end