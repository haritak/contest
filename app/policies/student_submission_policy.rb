class StudentSubmissionPolicy < SubmissionPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def preview?
    show?
  end
  def review_preview?
    show?
  end

  def create?
    user != nil
  end

  def new?
    user != nil
  end

  def make_final?
    unfinalize? or record.user == user
  end

  def unfinalize?
    user.is_admin? or user.is_secretary?
  end

  def admin_index?
    unfinalize?
  end

  def toggle_mark_ok?
    unfinalize?
  end

  def toggle_review_public?
    unfinalize?
  end

  def review_edit?
    unfinalize?
  end

  def review_set_note?
    unfinalize?
  end

  def export_xlsx?
    unfinalize? or user.is_secretary?
  end

  def download_exported_xlsx?
    unfinalize? or user.is_secretary?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.is_admin?
       scope.all
      else
        scope.where(user: user)
      end
     end
  end
end
