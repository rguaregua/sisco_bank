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
  end
end
