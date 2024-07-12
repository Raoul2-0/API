task :set_admin => :environment do
   user = User.find(ENV.fetch('ADMIN_USER'))
   user.add_role :admin
end