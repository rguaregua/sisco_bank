class ClientsController < ApplicationController
  before_action :initialize_service
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = @client_service.list_clients(index_query_params)
  end

  def show; end

  def new
    @client = Client.new
    set_date_inputs_from_client
  end

  def create
    attributes, date_errors = normalized_client_attributes
    @client = Client.new(attributes)
    date_errors.each { |error| @client.errors.add(:base, error) }

    if date_errors.empty? && @client.save
      redirect_to client_path(@client), notice: "Cliente creado correctamente"
    else
      set_date_inputs_from_params
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set_date_inputs_from_client
  end

  def update
    attributes, date_errors = normalized_client_attributes
    @client.assign_attributes(attributes)
    date_errors.each { |error| @client.errors.add(:base, error) }

    if date_errors.empty? && @client.save
      redirect_to client_path(@client), notice: "Cliente actualizado correctamente"
    else
      set_date_inputs_from_params
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client_service.delete_client(@client.id)
    redirect_to clients_path, notice: "Cliente eliminado correctamente"
  end

  private

  def initialize_service
    @client_service = ClientManagementService.new
  end

  def set_client
    @client = @client_service.get_client(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to clients_path, alert: "Cliente no encontrado"
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

  def normalized_client_attributes
    attributes = client_params.to_h
    date_errors = []

    %w[document_issued_at document_expires_at].each do |field|
      next if attributes[field].blank?

      parsed_date = parse_date_input(attributes[field])
      if parsed_date.nil?
        field_name = Client.human_attribute_name(field)
        date_errors << "#{field_name} debe tener formato DD-MM-AAAA o DD/MM/AAAA"
      else
        attributes[field] = parsed_date
      end
    end

    [attributes, date_errors]
  end

  def set_date_inputs_from_client
    @document_issued_at_input = @client.document_issued_at&.strftime("%d-%m-%Y")
    @document_expires_at_input = @client.document_expires_at&.strftime("%d-%m-%Y")
  end

  def set_date_inputs_from_params
    @document_issued_at_input = params.dig(:client, :document_issued_at)
    @document_expires_at_input = params.dig(:client, :document_expires_at)
  end
end
