require "rails_helper"

RSpec.describe ClientManagementService, type: :service do
  let(:service) { ClientManagementService.new }

  describe "Validacion Bancaria" do
    it "falla si el tipo de documento no corresponde al tipo de persona" do
      invalid_params = {
        type_of_person: "Natural",
        type_of_document: "RIF", # Error: RIF es solo para juridica
        document_number: "J12345678",
        document_issued_at: Date.today,
        document_expires_at: Date.today + 1.year,
        full_name: "Empresa Falsa",
        email: "test@bank.com",
        primary_phone: "02125555555"
      }

      result = service.create_client(invalid_params)
      expect(result.errors[:type_of_document]).to include("invalido para Persona Natural")
    end

    it "permite reutilizar telefono principal en clientes distintos" do
      first_params = {
        type_of_person: "Natural",
        type_of_document: "Cedula",
        document_number: "12345678",
        document_issued_at: Date.new(2020, 1, 15),
        document_expires_at: Date.new(2030, 1, 15),
        full_name: "Juan Perez",
        email: "juan.perez@email.com",
        primary_phone: "0999888777",
        secondary_phone: "0988777666"
      }

      second_params = first_params.merge(
        document_number: "87654321",
        email: "juan.duplicado@email.com"
      )

      created_client = service.create_client(first_params)
      expect(created_client).to be_persisted

      duplicated_client = service.create_client(second_params)
      expect(duplicated_client).to be_persisted
    end
  end
end
