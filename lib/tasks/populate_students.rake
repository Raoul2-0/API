require "#{Rails.root}/lib/utils"
require "#{Rails.root}/lib/student_module"
require "#{Rails.root}/lib/user_module"
include Utils
include StudentModule
include UserModule
task :populate_students => :environment do
  
  school_id = ENV.fetch('SCHOOL_ID') # school in which to population de news
  school = School.find(school_id)
  cycles = school.cycles.map(&:id)
  
  scholastic_period = school.current_scholastic_period
  scholastic_period_id = scholastic_period&.id

  temp = ENV.fetch('SCHOLASTIC_PERIOD_ID') if ENV.has_key?("SCHOLASTIC_PERIOD_ID")
  
  if temp && temp != ""
    scholastic_period_id ||= temp.to_i
    scholastic_period ||= school.current_scholastic_period(scholastic_period_id)
  end

  unless scholastic_period
    params = {
      denomination: "Année scolaire 2022-#{(2..9).to_a.sample(4).join}",
      description: "Objectif de cette année: #{(5..9).to_a.sample(2).join}% de \
      reussite au examens officiel et 85% aux examens de passage"
    }

    scolastic_period = ScholasticPeriod.new(params)
    school.institutions.create(institutionalisable: scolastic_period)
    save_resource_update_monitor(scolastic_period, "create", { user: user, monitor_attributes: { status: 4, start_date: (Date.current - 5).to_s, end_date: (Date.current + 5).to_s} })

    scolastic_period.reload
    scholastic_period_id = scholastic_period.id
  end

  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')

 student_params = { 
    student_attributes: {
      primary_school: ""
    },
    attend_attributes: {
      registration_number: rand(100_000_00..999_999_99).to_s,
      first_enrollment_date: "10-09-2021",
      school_id: school_id
    },
    attend_scholastic_period_attributes:{
      enrollment_date: "10-09-2022"
    }
  }

  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    begin
      cycle_id = cycles[[0, cycles.length - 1].sample]
      cycle = Cycle.find(cycle_id)
      classrooms = cycle.classrooms.map(&:id)
      resource = User.new(sign_up_params)
      resource.save!
      
      student_params[:student_attributes][:primary_school] = "Ecole primaire de Yaounde" + Random.new_seed.to_s[4, 8]
      student_params[:attend_attributes][:registration_number] = Random.new_seed.to_s[0, 8]
      student_params[:attend_attributes][:first_enrollment_date] = (Date.current - 10).to_s
      student_params[:attend_scholastic_period_attributes][:enrollment_date] = Date.current.to_s
      student_params[:attend_scholastic_period_attributes][:classroom_id] = classrooms[[0, classrooms.length - 1].sample]
      save_student(resource, student_params, resource, school_id, scholastic_period_id)

      puts("#{i} created")
    rescue Exception => e
      user = User.where(email: resource["email"]).first if resource
      user&.delete_in_school(school_id)

      puts("#{i} Error occur during the creation of a student")
    end 
  }
end