require "#{Rails.root}/lib/utils"
include Utils

task :initialize_monitorings => :environment do
models = ["theme", "school", "extra_activity", "table_description", 
  "user","attachment", "news", "event", "contact", "statistic", "collaborator", "generic", "gallery", "student", "attend", "attend_scholastic_period", "scholastic_period"]
  default_user = User.first
  models.each do |model|
    model_name = model.camelize.constantize
    model_name.all.each do |resource| 
      user = model.eql?("user") ? resource : default_user
      update_monitor(resource, Constant::RESOURCE_METHODS[:create], { user: user, monitor_attributes: { status: 4 } }) if resource.monitoring.nil?
    end
  end

end