# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record, :current_school

#, current_school) # 
  def initialize(user, record) 
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user[:user]
    @record = record
    @current_school = user[:current_school]
  end

  def admin?
    user&.admin?  || false
  end

  def school_admin?
    if staff_member?
      user&.school_admin?(record, current_school) || false
    else
      false # only staff member can be a school admin
    end
  end
  
  def staff_member?
    user&.is_staff? || false
  end
  
  def has_permission_in_school?(permission)
    user&.permission_in_school?(permission, record, current_school) || false
  end
  

  def is_admin_or_has_permission?(permission)
    admin? || school_admin? || has_permission_in_school?(permission)
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end
end
