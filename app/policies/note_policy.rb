class NotePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:team_lead) || user.has_cached_role?(:team_member)
        scope.where(company_id: user.company_id)
      else
        scope.joins(project: :project_accesses)
             .merge(ProjectAccess.where_permissions(:read_note).where("project_accesses.user_id=?", user.id))
      end
    end
  end

  def index?
    user.has_cached_role?(:team_lead) || user.has_cached_role?(:team_member)
  end

  def dashboard?
    true
  end

  def search?
    true
  end

  def show?
    user.company_id == record.company_id ||
      permissions&.read_note?
  end

  def create?
    (user.has_cached_role?(:team_lead) && user.company_id == record.company_id) ||
      permissions&.write_note?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def permissions
    ProjectAccess.where(user_id: user.id, project_id: record.project_id).first&.permissions
  end
end
