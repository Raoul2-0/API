require "#{Rails.root}/lib/utils"
include Utils
task :populate_cycles => :environment do
  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    params = {
      denomination: "cycle #{(1..9).to_a.sample(1).join}" + Time.now.to_s,
      description: "#{(5..9).to_a.sample(2).join} de \
      reussite au examens officiel et 85% aux examens de passage"
    }

    params["scholastic_period_id"] = ENV['SCHOLASTIC_PERIOD_ID'] || ScholasticPeriod.first.id
    cycle = Cycle.new(params)
    save_resource_update_monitor(cycle, "create", { user: user })
  } 
end