class SchoolPolicy < ApplicationPolicy
  def update?
    user.is_admin? or record.user == user
  end
  def edit?
    update?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def resolve
      if user.is_admin?
       scope.all
      else
        scope.where(user: user)
      end
     end
  end
end
