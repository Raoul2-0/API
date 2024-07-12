class ActivityStudentPolicy < ResourcePolicy
  def add_student?
    @user.admin?
  end

  def remove_student?
    @user.admin?
  end

  def manage_office?
    @user.admin?
  end
end