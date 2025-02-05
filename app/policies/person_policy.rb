class PersonPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def create?
    user != nil
  end

  def new?
    user != nil
  end

  def prepare_invitation_link?
    (create? and user == record.user) or user.is_admin?
  end

  def create_invitation_link?
    prepare_invitation_link?
  end

  def activate_invitation_link?
    prepare_invitation_link?
  end

  def deactivate_invitation_link?
    prepare_invitation_link?
  end

  def new_submission?
    prepare_invitation_link?
  end

  def new_typed_submission?
    new_submission?
  end

  def my_submissions?
    new_submission?
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
