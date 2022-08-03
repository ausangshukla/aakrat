class MaterialPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:team_lead) || user.has_cached_role?(:team_member)
        scope.where(company_id: user.company_id)
      else
        scope.joins(project: :project_accesses)
             .merge(ProjectAccess.where_permissions(:read_material).where("project_accesses.user_id=?", user.id))
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
    else
      permissions&.read_material?
    end
  end

  def create?
    user.company_id == record.company_id || permissions&.write_material?
  end

  def new?
    create?
  end

  def update?
    user.id == record.user_id
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
