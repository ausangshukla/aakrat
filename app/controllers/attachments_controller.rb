class AttachmentsController < ApplicationController
  before_action :set_attachment, only: %i[edit update destroy toggle_approval]

  # GET /attachments or /attachments.json
  def index
    @attachments = policy_scope(Attachment).with_attached_attachments.includes(attachments: :blob)
  end

  # GET /attachments/1 or /attachments/1.json
  def show
    @attachment = Attachment.with_attached_attachments.find(params[:id])
    authorize @attachment
  end

  # GET /attachments/new
  def new
    @attachment = Attachment.new(attachment_params)
    @attachment.company_id = @attachment.step.company_id
    @attachment.attached_by_id = current_user.id
    authorize @attachment
  end

  # GET /attachments/1/edit
  def edit
    @attachment.approval_status = params[:approval_status] if params[:approval_status]
  end

  # POST /attachments or /attachments.json
  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.project_id  ||= @attachment.step.project_id
    @attachment.phase_id    ||= @attachment.step.phase_id
    @attachment.company_id = @attachment.step.company_id
    @attachment.attached_by_id = current_user.id
    authorize @attachment

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to step_url(@attachment.step), notice: "Attachment was successfully created." }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachments/1 or /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to attachment_url(@attachment), notice: "Attachment was successfully updated." }
        format.json { render :show, status: :ok, location: @attachment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1 or /attachments/1.json
  def destroy
    @attachment.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@attachment)
        ]
      end
      format.html { redirect_to attachments_url, notice: "Attachment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_approval
    @attachment.approval_status = if params[:approval_status].present?
                                    params[:approval_status]
                                  else
                                    (@attachment.approval_status == "Approved" ? "Rejected" : "Approved")
                                  end
    @attachment.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(@attachment)
        ]
      end
      format.html { redirect_to step_url(@attachment), notice: "Attachment was successfully updated." }
      format.json { render :show, status: :ok, location: @attachment }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attachment
    @attachment = Attachment.find(params[:id])
    authorize @attachment
  end

  # Only allow a list of trusted parameters through.
  def attachment_params
    params.require(:attachment).permit(:name, :attached_by_id, :approval_status, :visible_to_client,
                                       :approved_by_id, :company_id, :project_id, :phase_id,
                                       :position, :step_id, :details, attachments: [])
  end
end
