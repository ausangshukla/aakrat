class MaterialsController < ApplicationController
  before_action :set_material, only: %i[show edit update destroy]

  # GET /materials or /materials.json
  def index
    @materials = policy_scope(Material)
  end

  # GET /materials/1 or /materials/1.json
  def show; end

  # GET /materials/new
  def new
    @material = Material.new(material_params)
    @material.company_id = @material.project.company_id
    @material.user_id = current_user.id
    authorize(@material)
  end

  # GET /materials/1/edit
  def edit; end

  # POST /materials or /materials.json
  def create
    @material = Material.new(material_params)
    @material.company_id = @material.project.company_id
    @material.user_id = current_user.id
    authorize(@material)

    respond_to do |format|
      if @material.save
        format.html { redirect_to material_url(@material), notice: "Material was successfully created." }
        format.json { render :show, status: :created, location: @material }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materials/1 or /materials/1.json
  def update
    respond_to do |format|
      if @material.update(material_params)
        format.html { redirect_to material_url(@material), notice: "Material was successfully updated." }
        format.json { render :show, status: :ok, location: @material }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materials/1 or /materials/1.json
  def destroy
    @material.destroy

    respond_to do |format|
      format.html { redirect_to materials_url, notice: "Material was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_material
    @material = Material.find(params[:id])
    authorize(@material)
  end

  # Only allow a list of trusted parameters through.
  def material_params
    params.require(:material).permit(:company_id, :project_id, :owner_id, :owner_type,
                                     :category, :item, :material, :description, :quantity, :unit_cost, :cost,
                                     :required_by_date, :reminder_days_before, attachments: [])
  end
end
