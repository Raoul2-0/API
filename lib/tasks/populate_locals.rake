require "#{Rails.root}/lib/utils"
include Utils
task :populate_locals => :environment do
  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to population the locals
  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    params = {
      denomination: "Local #{(1..9).to_a.sample(1).join}",
      description: "Local reservé aux élèves de #{(1..9).to_a.sample(1).join} années",
      capacity: [50, 45, 60, 35][rand(4)],
      localisation: "situé à cinq mètres de la salle des professeurs, juste à droite de \
      la bibliothèque"
    }
    local = Local.new(params)
    school.institutions.create(institutionalisable: local)
    #save_resource_update_monitor(local, "create", { user: user })
    update_monitor(local, "create", { user: user, monitor_attributes: { status: 4 } })
  } 
end