task :remove_admin => :environment do
  user = User.find(ENV.fetch('ADMIN_USER'))
  user.remove_role :admin
end