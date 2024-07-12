require "#{Rails.root}/lib/utils"
include Utils
task :populate_classrooms => :environment do
  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to population the locals
  
  specialties = school.specialties.map(&:id)
  cycles = school.cycles.map(&:id)
  locals = school.locals.map(&:id)
  class_levels = school.class_levels.map(&:id)

  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    class_level_id = class_levels[[0, class_levels.length - 1].sample]
    class_level = ClassLevel.find(class_level_id)

    params = {
      description: "Classroom description #{i}#{(1..9).to_a.sample(1).join}",
      cycle_id: 31, # cycles[[0, cycles.length - 1].sample],
      denomination: "#{class_level.denomination} #{(1..9).to_a.sample(1).join}",
      specialty_id: 112, #specialties[[0, specialties.length - 1].sample],
      local_id: locals[[0, locals.length - 1].sample],
      class_level_id: 311, #class_level_id,
      number_of_students: 0
    }

    classroom = Classroom.new(params)
    #save_resource_update_monitor(classroom, "create", { user: user })
    classroom.save
    update_monitor(classroom, "create", { user: user, monitor_attributes: { status: 4 } })
  } 
end