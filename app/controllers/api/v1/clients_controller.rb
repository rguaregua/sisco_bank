class Api::V1::ClientsController < ApplicationController
  before_action :initialize_service
  before_action :normalize_client_date_params, only: [ :create, :update ]

  # GET /api/v1/clients
  def index
    @clients = @client_service.list_clients(index_query_params)
    render json: @clients, meta: pagination_meta(@clients), adapter: :json
  end

  # GET /api/v1/clients/:id
  def show
    render json: @client_service.get_client(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("Cliente")
  end

  # POST /api/v1/clients
  def create
    @client = @client_service.create_client(client_params)
    if @client.errors.empty?
      render json: @client, status: :created
    else
      render_errors(@client.errors.full_messages)
    end
  end

  # PUT /api/v1/clients/:id
  def update
    @client = @client_service.update_client(params[:id], client_params)
    if @client.errors.empty?
      render json: @client
    else
      render_errors(@client.errors.full_messages)
    end
  rescue ActiveRecord::RecordNotFound
    render_not_found("Cliente")
  end

  # DELETE /api/v1/clients/:id
  def destroy
    @client_service.delete_client(params[:id])
    render_success(message: "Cliente eliminado correctamente")
  rescue ActiveRecord::RecordNotFound
    render_not_found("Cliente")
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

  def index_query_params
    request.query_parameters
           .slice("page", "per_page", "name", "document", "type_of_person")
           .with_indifferent_access
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

  def normalize_client_date_params
    return unless params[:client].present?

    date_fields = [ :document_issued_at, :document_expires_at ]

    date_fields.each do |field|
      next if params[:client][field].blank?

      parsed_date = parse_date_input(params[:client][field])
      unless parsed_date
        render_errors("#{field} debe tener formato DD-MM-AAAA o DD/MM/AAAA")
        return
      end

      params[:client][field] = parsed_date
    end
  end
end
