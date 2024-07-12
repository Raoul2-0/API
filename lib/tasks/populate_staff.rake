require "#{Rails.root}/lib/utils"
require "#{Rails.root}/lib/staff_module"
require "#{Rails.root}/lib/user_module"
include Utils
include StaffModule
include UserModule
task :populate_staff => :environment do
  school_id = ENV.fetch('SCHOOL_ID') # school in which to population de news
  school = School.find(school_id)
  jobs = school.jobs.map(&:id)
  profiles = school.profiles.map(&:id)
  departments = school.departments.map(&:id)

  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  
  (1..NUMBER_OF_RECORDS.to_i).each {|_i|
    begin
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
      save_staff(resource, parameters, resource, school_id)
    rescue Exception => e
      user = User.where(email: resource["email"]).first if resource
      user&.delete_in_school(school_id)

      puts("#{i} Error occur during the creation of a staff")
    end 
  }
  puts "DONE"
end