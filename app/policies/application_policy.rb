# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record, :perms

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "Must be logged in" unless user

    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end

  def permissions
    @perms ||= ProjectAccess.where(user_id: user.id, project_id: record.project_id).first&.permissions
    @perms
  end
end
