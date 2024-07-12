require "#{Rails.root}/lib/utils"
include Utils
task :populate_profiles => :environment do
  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to populate the profiles
  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    params = {
      denomination: "Dénomination profile #{(1..6).to_a.sample(1).join}",
      description: "Description profile #{(1..9).to_a.sample(1).join}"
    }
    profile = Profile.new(params)
    school.institutions.create(institutionalisable: profile)
    save_resource_update_monitor(profile, "create", { user: user })
  } 
end