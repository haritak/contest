class TeamPolicy < ApplicationPolicy
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

  def resend_school_approval?
    make_final?
  end

  def unfinalize?
    user.is_admin?
  end

  def admin_index?
    unfinalize? or user.is_secretary?
  end

  def export_xlsx?
    unfinalize? or user.is_secretary?
  end

  def download_exported_xlsx?
    unfinalize? or user.is_secretary?
  end

  def secretary_show?
    user.is_admin? or user.is_secretary?
  end


  def edit?
    user.is_admin? or (record.user == user and !record.finalized)
  end

  def update?
    edit?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def resolve
      if user.is_admin? or user.is_secretary?
       scope.all
      else
        scope.where(user: user)
      end
     end
  end
end
