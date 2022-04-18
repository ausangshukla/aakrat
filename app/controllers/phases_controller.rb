class PhasesController < ApplicationController
  before_action :set_phase, only: %i[show edit update destroy]

  # GET /phases or /phases.json
  def index
    @phases = policy_scope(Phase)
  end

  # GET /phases/1 or /phases/1.json
  def show; end

  # GET /phases/new
  def new
    @phase = Phase.new(phase_params)
    @phase.company_id = current_user.company_id
    @phase.project_id ||= params[:project_id]
    @phase.start_date = Time.zone.today
    @phase.end_date = Time.zone.today + 10.days
    authorize @phase
  end

  # GET /phases/1/edit
  def edit; end

  # POST /phases or /phases.json
  def create
    @phase = Phase.new(phase_params)
    @phase.company_id = current_user.company_id
    authorize @phase

    respond_to do |format|
      if @phase.save
        format.turbo_stream { render :create }
        format.html { redirect_to phase_url(@phase), notice: "Phase was successfully created." }
        format.json { render :show, status: :created, location: @phase }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phases/1 or /phases/1.json
  def update
    respond_to do |format|
      if @phase.update(phase_params)
        format.html { redirect_to phase_url(@phase), notice: "Phase was successfully updated." }
        format.json { render :show, status: :ok, location: @phase }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phases/1 or /phases/1.json
  def destroy
    @phase.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@phase)
        ]
      end
      format.html { redirect_to phases_url, notice: "Phase was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_phase
    @phase = Phase.find(params[:id])
    authorize @phase
  end

  # Only allow a list of trusted parameters through.
  def phase_params
    params.require(:phase).permit(:name, :start_date, :end_date, :status, :project_id,
                                  :assigned_to_id, :visible_to_client, :payment_status,
                                  :percentage_complete, :completed, :details)
  end
end
