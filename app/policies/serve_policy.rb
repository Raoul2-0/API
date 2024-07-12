class ServePolicy < ResourcePolicy
  def model_name
    'serve'
  end

  def create_permissions?
    user.admin?
  end
  def permissions?
    user.user?
  end
end