# lib/tasks/import_staff.rake
require "#{Rails.root}/lib/staff_module"
require "#{Rails.root}/lib/user_module"
include StaffModule
include UserModule
namespace :staff do
  desc "Create a single staff"

  task :create, %i[school_id profile_id email password admin] => :environment do |_, args|
    school_id = args[:school_id].to_i
    profile_id = args[:profile_id].to_i
    email = args[:email]
    password = args[:password]
    school_admin = args[:admin]

    unless School.exists?(school_id)
      puts "School with ID #{school_id} not found."
      exit
    end

    unless profile_id.present?
      puts "Can't create staff with profile #{school_id}."
      exit
    end

    if email.blank? || User.find_by_email(email).present?
      puts "Email is blank or It has already been taken. #{email}! I can't create this user."
      next
    end

    current_school = School.find(school_id)

    if profile_id == 1 && current_school.principal.present?
      puts "The principal already exist for the school #{current_school.denomination} and his name is #{current_school.principal.fullname}"
      exit
    end


    sign_up_extra_params = {
      email: email,
      password: password || "Password1234",
    }

    staff_extra_params = {
      serve_attributes: {
        profile_id: profile_id, 
        job_id: profile_id,
        is_school_admin: school_admin == 'true',
        first_serving_date: (Date.current - 1000).to_s,
      }
    }

    resource = User.new(sign_up_params(sign_up_extra_params))
    resource.save!

    final_staff_params = staff_params(staff_extra_params)
    parameters = {
      staff_attributes: final_staff_params[:staff_attributes],
      serve_attributes: final_staff_params[:serve_attributes]
    }
    save_staff(resource, parameters, resource, school_id)

    puts "DONE"
  end

end
