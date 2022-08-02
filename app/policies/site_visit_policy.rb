class SiteVisitPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:team_lead)
        scope.where(company_id: user.company_id)
      elsif user.has_cached_role?(:team_member)
        scope.where(assigned_to_id: user.id)
      else
        scope.joins(project: :project_accesses)
             .merge(ProjectAccess.where_permissions(:read_site_visit).where("project_accesses.user_id=?", user.id))
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
      permissions&.read_site_visit?
    end
  end

  def create?
    (user.has_cached_role?(:team_lead) && user.company_id == record.company_id) ||
      permissions&.write_site_visit?
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

  def clone?
    update?
  end

  def clone_phases?
    update?
  end

  def destroy?
    update?
  end
end
