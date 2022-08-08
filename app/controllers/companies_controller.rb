class CompaniesController < ApplicationController
  before_action :set_company, only: %w[show update destroy edit]
  after_action :verify_authorized, except: %i[dashboard search index investor_companies]

  # GET /companies or /companies.json
  def index
    @companies = policy_scope(Company)
    render "index", locals: { vc_view: false }
  end

  def dashboard
    @companies = Company.all
  end

  def investor_companies
    @companies = Company.for_investor(current_user)
    render "index", locals: { vc_view: true }
  end

  def search
    @companies = Company.search(params[:query], star: true)

    render "index", locals: { vc_view: true }
  end

  # GET /companies/1 or /companies/1.json
  def show; end

  # GET /companies/new
  def new; end

  # GET /companies/1/edit
  def edit; end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)
    @company.created_by = current_user.id
    authorize @company

    respond_to do |format|
      if @company.save
        format.html { redirect_to company_url(@company), notice: "Company was successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_company }
        format.json { render json: @company.errors, status: :unprocessable_company }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to company_url(@company), notice: "Company was successfully updated." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_company }
        format.json { render json: @company.errors, status: :unprocessable_company }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url, notice: "Company was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id])
    authorize @company
  end

  # Only allow a list of trusted parameters through.
  def company_params
    params.require(:company).permit(:name, :url, :category, :founded, :company_type,
                                    :funding_amount, :funding_unit, :details, :logo_url,
                                    :investor_categories, :instrument_types, :entity_names,
                                    :currency, :units, :address, :gst_number, :logo)
  end
end
