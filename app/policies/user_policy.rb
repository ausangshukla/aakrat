class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:team_lead) || user.has_cached_role?(:team_member)
        scope.where(company_id: user.company_id)
      else
        scope.none
      end
    end
  end

  def index?
    true
  end

  def welcome?
    true
  end

  def show?
    user.id == record.id || user.company_id == record.company_id
  end

  def create?
    user.has_cached_role?(:team_lead) && user.company_id == record.company_id
  end

  def new?
    user.has_cached_role?(:team_lead) && user.company_id == record.company_id
  end

  def update?
      user.id == record.id ||
      (user.company_id == record.company_id && user.has_cached_role?(:team_lead))
  end

  def edit?
    update?
  end

  def destroy?
    false
  end
end
