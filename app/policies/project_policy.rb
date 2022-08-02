class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:team_lead) || user.has_cached_role?(:team_member)
        scope.where(company_id: user.company_id)
      else
        scope.joins(:project_accesses)
             .merge(ProjectAccess.where_permissions(:read_project).where("project_accesses.user_id=?", user.id))
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
    user.company_id == record.company_id || permissions&.read_project?
  end

  def create?
    user.has_cached_role?(:team_lead) && user.company_id == record.company_id
  end

  def new?
    create?
  end

  def update?
    create? || permissions&.write_project?
  end

  def edit?
    update?
  end

  def clone?
    update?
  end

  def clone_phases?
    update?
  end

  def destroy?
    update?
  end

  def action?
    user.company_id == record.company_id
  end

  def permissions
    @perms ||= ProjectAccess.where(user_id: user.id, project_id: record.id).first&.permissions
    @perms
  end
end
