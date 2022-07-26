class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]
  after_action :verify_authorized, except: %i[index search]

  # GET /clients or /clients.json
  def index
    @clients = policy_scope(Client)
    @clients = @clients.where(user_type: params[:user_type]) if params[:user_type]
    @clients = @clients.where(user_id: params[:user_id]) if params[:user_id]
  end

  def search
    @clients = Client.search(params[:term].to_s, star: true, with: { company_id: current_user.company_id })
    Rails.logger.debug @clients.to_json
    render "index"
  end

  # GET /clients/1 or /clients/1.json
  def show; end

  # GET /clients/new
  def new
    @client = Client.new(client_params)
    @client.company_id = current_user.company_id
    authorize @client
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients or /clients.json
  def create
    @client = Client.new(client_params)
    @client.company_id = current_user.company_id
    authorize @client

    respond_to do |format|
      if @client.save
        format.html { redirect_to client_url(@client), notice: "Client was successfully created." }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_url(@client), notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
    authorize @client
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:client).permit(:first_name, :last_name, :email, :phone, :user_id,
                                   :details, :company_id, :user_type, :address)
  end
end
