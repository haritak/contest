# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user&.is_admin? or user&.is_secretary? or user&.is_reviewer or 
      (record and record.user and record.user == user)
  end

  def admin_index?
    user&.is_admin?
  end

  def show?
    index?
  end

  def create?
    user&.is_admin?
  end

  def new?
    false
  end

  def update?
    index?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
