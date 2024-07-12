class ResourcePolicy < ApplicationPolicy
  include DefaultPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end