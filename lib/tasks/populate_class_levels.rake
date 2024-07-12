require "#{Rails.root}/lib/utils"
include Utils
task :populate_class_levels => :environment do
 class_levels = [
  {
    denomination: "6ème",
    description: "Niveau 1 du lycée/collegue"
  },
  {
    denomination: "5ème",
    description: "Niveau 2 du lycée/collegue"
  },
  {
    denomination: "4ème",
    description: "Niveau 3 du lycée/collegue"
  },
  {
    denomination: "3ème",
    description: "Niveau 4 du lycée/collegue"
  },
  {
    denomination: "Seconde",
    description: "Niveau 5 du lycée/collegue"
  },
  {
    denomination: "Première",
    description: "Niveau 6 du lycée/collegue"
  },
  {
    denomination: "Terminal",
    description: "Niveau 7 du lycée/collegue"
  },
 ]
  
# user = User.with_role(:admin).first # this user shoud be and admin user in the db (the first admin is taken)
#   school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to population de news
#   class_levels.each {|class_level_params|
#     class_level = ClassLevel.new(class_level_params)
#     school.institutions.create(institutionalisable: class_level)
#     save_resource_update_monitor(class_level, "create", { user: user }) 
#   } 
end