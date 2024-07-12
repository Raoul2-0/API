class MonitoringPolicy < ResourcePolicy
  def model_name
    'monitoring'
  end
  
  def update_attributes_monitor_of_resources?
    user.admin?
  end
end