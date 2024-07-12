require 'faker'
require 'factory_bot_rails'

module CourseGeneralityHelpers

    def course_generality_parameters
        {
            denomination: Faker::Lorem.word,
            description: Faker::Lorem.paragraph,
            duration: Faker::Lorem.word
        }
    end 

    def create_course_generality
        
        handle_monitoring(FactoryBot.create(:course_generality, course_generality_parameters))
    end

    def build_course_generality
        
        FactoryBot.build(:course_generality, course_generality_parameters)
    end

    def course_generality_payload(course_generality, success=true)
        if success
        {
            denomination: course_generality.denomination,
            description: course_generality.description,
            duration:  course_generality.duration
        }
        end
    end

    def verify_all_course_attributes_updated(new_course_generality, course_generality_saved)
        # binding.pry
        expect(course_generality_saved.denomination).to eq(new_course_generality.denomination)
        expect(course_generality_saved.description).to eq(new_course_generality.description)
        expect(course_generality_saved.duration).to eq(new_course_generality.duration)
    end
end