require "#{Rails.root}/lib/utils"
include Utils
task :populate_evaluation_types => :environment do
  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to populate the evaluation types
  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    params = {
      denomination: "Séquence #{(1..6).to_a.sample(1).join}",
      description: "Objectif de cette séquence: #{(5..9).to_a.sample(2).join}% de \
      reussite après évaluation des élèves"
    }
    evaluation_type = EvaluationType.new(params)
    school.institutions.create(institutionalisable: evaluation_type)
    save_resource_update_monitor(evaluation_type, "create", { user: user })
  } 
end