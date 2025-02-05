class SubmissionPolicy < ApplicationPolicy
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

  def make_final?
    user.is_admin? or record.user == user
  end

  def unfinalize?
    user.is_admin?
  end

  def edit?
    user.is_admin? or (record.user == user and !record.finalized)
  end

  def update?
    edit?
  end

  def admin_index?
    unfinalize? or user.is_secretary?
  end

  def toggle_reviewed?
    admin_index?
  end

  def save_review_notes?
    admin_index?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.is_admin? or user.is_secretary?
       scope.all
      else
        scope.where(user: user)
      end
     end
  end
end
