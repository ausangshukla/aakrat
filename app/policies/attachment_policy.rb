class AttachmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:team_lead) || user.has_cached_role?(:team_member)
        scope.where(company_id: user.company_id)
      else
        scope.joins(project: :project_accesses).visible_to_client
             .merge(ProjectAccess.where_permissions(:read_note).where("project_accesses.user_id=?", user.id))
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
    elsif user.has_cached_role?(:client)
      permissions&.read_attachment? && record.visible_to_client
    else
      permissions&.read_attachment?
    end
  end

  def create?
    (user.has_cached_role?(:team_member) && user.company_id == record.company_id) ||
      permissions&.write_attachment?
  end

  def new?
    create?
  end

  def toggle_approval?
    user.has_cached_role?(:team_lead) && user.company_id == record.company_id
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

  def toggle_completed?
    update?
  end
end
