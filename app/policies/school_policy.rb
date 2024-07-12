class SchoolPolicy < ResourcePolicy
  
  def model_name
    'school'
  end

  def assign_theme?
    is_admin_or_has_permission?("#{model_name}:assign_theme")
  end

end
