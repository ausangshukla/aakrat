class DailyActivitiesController < ApplicationController
  before_action :set_daily_activity, only: %i[show edit update destroy]

  # GET /daily_activities or /daily_activities.json
  def index
    @daily_activities = policy_scope(DailyActivity)
  end

  # GET /daily_activities/1 or /daily_activities/1.json
  def show; end

  # GET /daily_activities/new
  def new
    @daily_activity = DailyActivity.new(daily_activity_params)
    @daily_activity.company_id = @daily_activity.step.company_id
    @daily_activity.user_id = current_user.id if @daily_activity.company_id != current_user.company_id
    @daily_activity.on_date = Time.zone.today
    authorize @daily_activity
  end

  # GET /daily_activities/1/edit
  def edit; end

  # POST /daily_activities or /daily_activities.json
  def create
    @daily_activity = DailyActivity.new(daily_activity_params)
    @daily_activity.company_id = @daily_activity.step.company_id
    @daily_activity.project_id = @daily_activity.step.project_id
    @daily_activity.user_id = current_user.id if @daily_activity.company_id != current_user.company_id
    authorize @daily_activity

    respond_to do |format|
      if @daily_activity.save
        format.html { redirect_to daily_activity_url(@daily_activity), notice: "Daily activity was successfully created." }
        format.json { render :show, status: :created, location: @daily_activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @daily_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_activities/1 or /daily_activities/1.json
  def update
    respond_to do |format|
      if @daily_activity.update(daily_activity_params)
        format.html { redirect_to daily_activity_url(@daily_activity), notice: "Daily activity was successfully updated." }
        format.json { render :show, status: :ok, location: @daily_activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @daily_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_activities/1 or /daily_activities/1.json
  def destroy
    @daily_activity.destroy

    respond_to do |format|
      format.html { redirect_to daily_activities_url, notice: "Daily activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_daily_activity
    @daily_activity = DailyActivity.find(params[:id])
    authorize @daily_activity
  end

  # Only allow a list of trusted parameters through.
  def daily_activity_params
    params.require(:daily_activity).permit(:user_id, :company_id, :project_id, :step_id,
                                           :on_date, :title, :details, :status, :cost, :quantity)
  end
end
