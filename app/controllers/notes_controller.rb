class NotesController < ApplicationController
  before_action :set_note, only: %i[edit update destroy]

  # GET /notes or /notes.json
  def index
    @notes = policy_scope(Note)
  end

  # GET /notes/1 or /notes/1.json
  def show
    @note = Note.with_attached_attachments.find(params[:id])
    authorize @note
  end

  # GET /notes/new
  def new
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    @note.project_id = @note.owner.project_id if @note.owner
    @note.company_id = @note.project.company_id if @note.project
    authorize @note
  end

  # GET /notes/1/edit
  def edit; end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    @note.project_id = @note.owner.project_id if @note.owner
    @note.company_id = @note.project.company_id if @note.project
    authorize @note

    respond_to do |format|
      if @note.save
        format.html { redirect_to note_url(@note), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      @note.user_id = current_user.id
      if @note.update(note_params)
        format.html { redirect_to note_url(@note), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy

    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
    authorize @note
  end

  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:user_id, :company_id, :project_id, :owner_id,
                                 :owner_type, :details, attachments: [])
  end
end
