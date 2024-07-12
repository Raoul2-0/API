class NilClassPolicy < ApplicationPolicy
  def show?
    false
  end
end