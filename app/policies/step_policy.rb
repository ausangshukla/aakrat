class StepPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:team_lead) || user.has_cached_role?(:team_member)
        scope.where(company_id: user.company_id)
      elsif user.has_cached_role?(:client)
        scope.joins(project: :project_accesses).visible_to_client
             .merge(ProjectAccess.where_permissions(:read_step).where("project_accesses.user_id=?", user.id))
      else
        scope.joins(project: :project_accesses)
             .merge(ProjectAccess.where_permissions(:read_step).where("project_accesses.user_id=?", user.id))
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
    if user.company_id == record.company_id
      true
    elsif user.has_cached_role?(:client)
      permissions&.read_step? && record.visible_to_client
    else
      permissions&.read_step?
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
    (create? && (record.assigned_to_id == user.id || user.has_cached_role?(:team_lead))) ||
      permissions&.write_step?
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

  def attachment?
    user.company_id == record.company_id
  end

  def add_note?
    user.company_id == record.company_id
  end
end
