require "#{Rails.root}/lib/utils"
include Utils
task :populate_jobs => :environment do
 jobs = [
  {
    denomination: "Surveillant",
    description: "Surveillant général et de secteur du lycée/collège"
  },
  {
    denomination: "Censeur",
    description: "Censeur du lycée/collège "
  },
  {
    denomination: "Conseiller d'orientation",
    description: "Conseiller d'orientation du lycée/collegue"
  },
  {
    denomination: "Bibliothécaire",
    description: "Bibliothécaire du lycée/collegue"
  },
  {
    denomination: "Proviseur",
    description: "Proviseur du lycée/collegue"
  },
  {
    denomination: "Jardinier",
    description: "Jardinier du lycée/collegue"
  },
  {
    denomination: "Gardien",
    description: "Gardien du lycée/collegue"
  },
  {
    denomination: "Enseignant",
    description: "Enseignant du lycée/collegue"
  },
 ]
  
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to population de news
  jobs.each {|job_params|
    job = Job.new(job_params)
    school.institutions.create(institutionalisable: job)
    save_resource_update_monitor(job, "create", { user: user }) 
  } 
end