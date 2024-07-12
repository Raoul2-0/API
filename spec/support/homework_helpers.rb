require 'faker'
require 'factory_bot_rails'
require "#{Rails.root}/lib/utils"
require "#{Rails.root}/lib/staff_module"
require "#{Rails.root}/lib/user_module"
include Utils
include ServeModule
include UserModule

module HomeworkHelpers

  def homework_parameters(serve,course)

    {
      denomination: Faker::Lorem.word,
      description: Faker::Lorem.paragraph,
      optional: false,
      due_date: Faker::Date.in_date_period(year: 2024, month: 6),
      homeworkable_type: "Course",
      homeworkable_id: course.id,
      serve: serve
    }
  end

  def create_serve(school)
    # school_id = ENV.fetch('SCHOOL_ID') # school in which to populate news
    # school = School.find(school_id)
    jobs = school.jobs.map(&:id)
    profiles = school.profiles.map(&:id)
    departments = school.departments.map(&:id)

    resource = User.new(sign_up_params)
    resource.save!
    staff_params[:serve_attributes][:job_id] = jobs[[0, jobs.length - 1].sample]
    staff_params[:serve_attributes][:profile_id] = profiles[[0, profiles.length - 1].sample]
    staff_params[:serve_attributes][:departement_id] = departments[[0, departments.length - 1].sample]
    staff_params[:serve_attributes][:first_serving_date] = (Date.current - 1000).to_s
    staff_params[:serve_attributes][:is_school_admin] = [true, false][rand(2)]
    parameters = {
      staff_attributes: staff_params[:staff_attributes],
      serve_attributes: staff_params[:serve_attributes]
    }
    serve = save_staff(resource, parameters, resource, school.id)
    
    serve
  end

  def create_homework(serve,course)
    handle_monitoring(FactoryBot.create(:homework, homework_parameters(serve,course)))
  end

  def build_homework(serve,course)
    FactoryBot.build(:homework, homework_parameters(serve,course))
  end

  def homework_payload(homework, success=true)
    if success
      {
        denomination: homework.denomination,
        description: homework.description,
        due_date:  homework.due_date,
        optional: homework.optional,
        serve_id: homework.serve_id,
        homeworkable_type: homework.homeworkable_type,
        homeworkable_id: homework.homeworkable_id
      }
    end
  end

  def verify_all_homework_attributes_updated(new_homework, homework_saved)
    # binding.pry
    expect(homework_saved.denomination).to eq(new_homework.denomination)
    expect(homework_saved.description).to eq(new_homework.description)
    expect(homework_saved.due_date).to eq(new_homework.due_date)
    expect(homework_saved.optional).to eq(new_homework.optional)
    expect(homework_saved.serve_id).to eq(new_homework.serve_id)
  end

end
