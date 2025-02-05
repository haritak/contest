class UserPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  #
  def show?
    user&.is_admin? or record == user
  end

  def edit?
    user&.is_admin? # TODO or record == user
  end

  def update?
    user&.is_admin? # TODO or record == user
  end

  def make_participation_final?
    user.is_admin? or user == user
  end

  def make_participation_to_seminar_final?
    make_participation_final?
  end

  def unfinalize_participation?
    user.is_admin?
  end

  def unfinalize_participation_to_seminar?
    unfinalize_participation?
  end

  def become?
    user.is_admin?
  end

  def manualy_confirm?
    user.is_admin?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def resolve
      return [] if not user
      if user.is_admin?
       scope.all
      else
        scope.where(id: user.id)
      end
     end
  end
end
