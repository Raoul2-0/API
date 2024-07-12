class UserPolicy < ResourcePolicy
  def model_name
    'user'
  end

  def add_role?
    @user.has_role? :admin
  end
end
