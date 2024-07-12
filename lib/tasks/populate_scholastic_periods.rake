require "#{Rails.root}/lib/utils"
include Utils
task :populate_scholastic_periods => :environment do
  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  user = ENV[:ADMIN_USER.to_s] ? User.find(ENV.fetch('ADMIN_USER')) : User.by_admin.first # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to population de news
  
  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    params = {
      denomination: "Année scolaire 2022-#{(2..9).to_a.sample(4).join}",
      description: "Objectif de cette année: #{(5..9).to_a.sample(2).join}% de \
      reussite au examens officiel et 85% aux examens de passage"
    }
    scolastic_period = ScholasticPeriod.new(params)
    school.institutions.create(institutionalisable: scolastic_period)
    random_time_1, random_time_2 = generate_random_date 
    monitor_attributes ={ start_date: random_time_1, end_date: random_time_2 }
    save_resource_update_monitor(scolastic_period, "create", { user: user, monitor_attributes: monitor_attributes }) 
  } 
end