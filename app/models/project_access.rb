class ProjectAccess < ApplicationRecord
  ROLES = %w[Client Accountant Contractor].freeze

  belongs_to :company
  belongs_to :user
  belongs_to :project

  flag :permissions, %i[read_project write_project read_step write_step read_phase write_phase read_payment write_payment read_site_visit write_site_visit read_note write_note read_quote write_quote read_attachment write_attachment read_daily_activity write_daily_activity]

  has_rich_text :details

  scope :for, ->(user, roles) { where("project_accesses.user_id=? and project_accesses.role_name in (?)", user.id, roles) }

  def set_client_perms
    client_perms = %i[read_step write_step read_phase write_phase read_payment write_payment read_site_visit write_site_visit]
    client_perms.each do |perm|
      permissions.set(perm)
    end
  end

  def set_accountant_perms
    accountant_perms = %i[read_step read_phase read_payment write_payment read_site_visit]
    accountant_perms.each do |perm|
      permissions.set(perm)
    end
  end
end
