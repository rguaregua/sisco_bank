class Api::V1::ClientsController < ApplicationController
  before_action :initialize_service

  # GET /api/v1/clients
  def index
    @clients = @client_service.list_clients(params)
    render json: @clients, meta: pagination_meta(@clients), adapter: :json
  end

  # GET /api/v1/clients/:id
  def show
    render json: @client_service.get_client(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cliente no encontrado" }, status: :not_found
  end

  # POST /api/v1/clients
  def create
    @client = @client_service.create_client(client_params)
    if @client.errors.empty?
      render json: @client, status: :created
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/clients/:id
  def update
    @client = @client_service.update_client(params[:id], client_params)
    if @client.errors.empty?
      render json: @client, status: :ok
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cliente no encontrado" }, status: :not_found
  end

  # DELETE /api/v1/clients/:id
  def destroy
    @client_service.delete_client(params[:id])
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cliente no encontrado" }, status: :not_found
  end

  private

  def initialize_service
    @client_service = ClientManagementService.new
  end

  def client_params
    params.require(:client).permit(
      :type_of_person,
      :type_of_document,
      :document_number,
      :document_issued_at,
      :document_expires_at,
      :full_name,
      :email,
      :primary_phone,
      :secondary_phone
    )
  end

  def pagination_meta(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count
    }
  end
end
