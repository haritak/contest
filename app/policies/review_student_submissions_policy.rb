class ReviewStudentSubmissionsPolicy < ApplicationPolicy
  def method_missing
    user&.is_admin? or user&.is_reviewer?
  end
end

