require "#{Rails.root}/lib/utils"
include Utils
task :populate_departments => :environment do
 departments = [
  {
    denomination: "Département d'Informatique",
    description: "Département 1 du lycée/collège"
  },
  {
    denomination: "Département de Physique",
    description: "Département 2 du lycée/collège"
  },
  {
    denomination: "Département d'Histoire",
    description: "Département 3 du lycée/collège"
  },
  {
    denomination: "Département de Mathématiques",
    description: "Département 4 du lycée/collège"
  },
  {
    denomination: "Département de Français",
    description: "Département 5 du lycée/collège"
  },
  {
    denomination: "Département de Geographie",
    description: "Département 6 du lycée/collège"
  },
  {
    denomination: "Département des Sciences de la vie et de la terre",
    description: "Département 7 du lycée/collège"
  },
  {
    denomination: "Département de ECM",
    description: "Département 8 du lycée/collège"
  },
  {
    denomination: "Département de Philosophie",
    description: "Département 9 du lycée/collège"
  },
  {
    denomination: "Département de Sport",
    description: "Département 10 du lycée/collège"
  },
  {
    denomination: "Département d'Anglais",
    description: "Département 11 du lycée/collège"
  },
  {
    denomination: "Département de Chimie",
    description: "Département 12 du lycée/collège"
  },
 ]
  
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to population de news
  departments.each { |department_params|
    department = Department.new(department_params)
    school.institutions.create(institutionalisable: department)
    save_resource_update_monitor(department, "create", { user: user }) 
  } 
end