class WelcomePolicy < ApplicationPolicy
  def switch_autonomous_submissions?
    user&.is_admin?
  end

  def switch_hide_students?
    user&.is_admin?
  end

  def switch_enable_coadmin?
    user&.is_admin?
  end

  def switch_shutdown_previews?
    user&.is_admin?
  end

  def set_seminar_participation_deadline?
    user&.is_admin?
  end
end
