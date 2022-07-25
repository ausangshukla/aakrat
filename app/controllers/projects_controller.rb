class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy clone_phases clone]
  after_action :verify_authorized, except: %i[index search delete_attachment]

  # GET /projects or /projects.json
  def index
    @projects = policy_scope(Project).includes(:project_accesses)

    cookies[:project_status] = "In Progress" if params[:status].blank? && cookies[:project_status].blank?

    if params[:status].present?
      @projects = @projects.where(status: params[:status]) if params[:status] != "Any Status"
    elsif cookies[:project_status].present?
      @projects = @projects.where(status: cookies[:project_status]) if cookies[:project_status] != "Any Status"
    end
  end

  # GET /projects/1 or /projects/1.json
  def show; end

  # GET /projects/new
  def new
    @project = Project.new(project_params)
    @project.company_id = current_user.company_id
    @project.team_lead_id = current_user.id

    authorize(@project)
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.company_id = current_user.company_id
    @project.team_lead_id = current_user.id
    authorize @project

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.status = "Archived"
    @project.save

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def clone
    @clone = @project.dup
    @clone.cloned_from = @project.id
    @clone.name = "Cloned from #{@project.name}"
    @clone.start_date = Time.zone.today
    @clone.end_date = Time.zone.today + (@project.end_date - @project.start_date).to_i.days
    @clone.status = "Not Started"

    @clone.save

    respond_to do |format|
      format.html { redirect_to edit_project_url(@clone), notice: "Please change key fields in the project. Then click 'Clone Phases' button" }
      format.json { render :show, status: :ok, location: @clone }
    end
  end

  def clone_phases
    CloneProjectJob.perform_later(@project.cloned_from, @project.id)
    respond_to do |format|
      format.html { redirect_to project_url(@project), notice: "Please be patient, copying stages takes some time. Checkback in a minute." }
      format.json { render :show, status: :ok, location: @project }
    end
  end

  # Special method to delete attachments for any model
  def delete_attachment
    attachment = ActiveStorage::Attachment.where(id: params[:attachment_id]).first
    record = attachment.record
    if policy(record).update?
      attachment.purge_later
      redirect_to record, notice: "Attachment Deleted"
    else
      redirect_to record, notice: "Attachment Deletion Failed: Access Denied"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
    authorize @project
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:name, :start_date, :end_date, :client_id,
                                    :payment_amount, :client_estimated_budget,
                                    :estimated_builtup_area, :actual_builtup_area,
                                    :actual_cost, :fees, :per_sq_ft_rate, :percentage_of_estimated_budget,
                                    :percentage_completed, :status, :company_id, :details, :entity_name,
                                    :project_type, :scale, :style, :pattern, :address, :discount,
                                    :fee_type, :details, services: [], profile_pics: [])
  end
end
