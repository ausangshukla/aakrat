class StepPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      else
        scope.where(company_id: user.company_id)
      end
    end
  end

  def index?
    true
  end

  def dashboard?
    true
  end

  def search?
    true
  end

  def show?
    if user.has_cached_role?(:super) || user.company_id == record.company_id
      true
    else
      user.company_id != record.id
    end
  end

  def create?
    user.has_cached_role?(:team_member) && user.company_id == record.company_id
  end

  def new?
    create?
  end

  def approve?
    user.has_cached_role?(:team_lead) && user.company_id == record.company_id
  end

  def update?
    create? && (record.assigned_to_id == user.id || user.has_cached_role?(:team_lead))
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def toggle_completed?
    update?
  end
end
