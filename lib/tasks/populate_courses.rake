require "#{Rails.root}/lib/utils"
include Utils
task :populate_courses => :environment do
  school_id = ENV.fetch('SCHOOL_ID') # school in which to population de news
  school = School.find(school_id)
  scholastic_period = school.current_scholastic_period
  scholastic_period_id = scholastic_period&.id || ENV.fetch('SCHOLASTIC_PERIOD_ID')
  
  cycles = school.cycles.map(&:id)

  courses = [
    {
      denomination: "Informatique",
      description: "Département 1 du lycée/collège"
    },
    {
      denomination: "Physique",
      description: "Département 2 du lycée/collège"
    },
    {
      denomination: "Histoire",
      description: "Département 3 du lycée/collège"
    },
    {
      denomination: "Mathématiques",
      description: "Département 4 du lycée/collège"
    },
    {
      denomination: "Français",
      description: "Département 5 du lycée/collège"
    },
    {
      denomination: "Geographie",
      description: "Département 6 du lycée/collège"
    },
    {
      denomination: "Sciences de la vie et de la terre",
      description: "Département 7 du lycée/collège"
    },
    {
      denomination: "ECM",
      description: "Département 8 du lycée/collège"
    },
    {
      denomination: "Philosophie",
      description: "Département 9 du lycée/collège"
    },
    {
      denomination: "Sport",
      description: "Département 10 du lycée/collège"
    },
    {
      denomination: "Anglais",
      description: "Département 11 du lycée/collège"
    },
    {
      denomination: "Chimie",
      description: "Département 12 du lycée/collège"
    }
  ]
  
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to population de news
  courses.each { |course_params|
    cycle_id = cycles[[0, cycles.length - 1].sample]
    cycle = Cycle.find(cycle_id)
    classrooms = cycle.classrooms.map(&:id)

    extra_params = {
      classroom_id: classrooms[[0, classrooms.length - 1].sample],
      scholastic_period_id: scholastic_period_id
    }
    course = Course.new(course_params.merge(extra_params))
    school.institutions.create(institutionalisable: course)
    save_resource_update_monitor(course, "create", { user: user }) 
  } 
end