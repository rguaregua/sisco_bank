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
        primary_phone: "04141234567"
      }

      result = service.create_client(invalid_params)
      expect(result.errors[:type_of_document]).to include("inválido para Persona Natural")
    end

    it "falla si persona juridica usa un documento distinto a RIF" do
      invalid_params = {
        type_of_person: "Juridica",
        type_of_document: "Cedula",
        document_number: "J12345679",
        document_issued_at: Date.today,
        document_expires_at: Date.today + 1.year,
        full_name: "Empresa Prueba",
        email: "empresa@test.com",
        primary_phone: "04141234568"
      }

      result = service.create_client(invalid_params)
      expect(result.errors[:type_of_document]).to include("debe ser RIF para Persona Jurídica")
    end

    it "falla si persona juridica con RIF no cumple el formato venezolano" do
      invalid_params = {
        type_of_person: "Juridica",
        type_of_document: "RIF",
        document_number: "J123456789",
        document_issued_at: Date.today,
        document_expires_at: Date.today + 1.year,
        full_name: "Empresa Prueba",
        email: "empresa.rif@test.com",
        primary_phone: "04141234569"
      }

      result = service.create_client(invalid_params)
      expect(result.errors[:document_number]).to include("debe tener formato RIF valido (Ej: J-12345678-9)")
    end

    it "falla si persona natural con cedula no cumple formato venezolano" do
      invalid_params = {
        type_of_person: "Natural",
        type_of_document: "Cedula",
        document_number: "12345678",
        document_issued_at: Date.today,
        document_expires_at: Date.today + 1.year,
        full_name: "Persona Prueba",
        email: "persona.cedula@test.com",
        primary_phone: "04141234571"
      }

      result = service.create_client(invalid_params)
      expect(result.errors[:document_number]).to include("debe tener formato de cédula valido (Ej: V-12345678)")
    end

    it "permite persona natural con cedula en formato valido" do
      valid_params = {
        type_of_person: "Natural",
        type_of_document: "Cedula",
        document_number: "V-12345678",
        document_issued_at: Date.today,
        document_expires_at: Date.today + 1.year,
        full_name: "Persona Valida",
        email: "persona.valida@test.com",
        primary_phone: "04141234572"
      }

      result = service.create_client(valid_params)
      expect(result).to be_persisted
    end

    it "permite persona juridica con RIF en formato valido" do
      valid_params = {
        type_of_person: "Juridica",
        type_of_document: "RIF",
        document_number: "J-12345678-9",
        document_issued_at: Date.today,
        document_expires_at: Date.today + 1.year,
        full_name: "Empresa Formato",
        email: "empresa.valida@test.com",
        primary_phone: "04141234570"
      }

      result = service.create_client(valid_params)
      expect(result).to be_persisted
    end

    it "permite reutilizar telefono principal en clientes distintos" do
      first_params = {
        type_of_person: "Natural",
        type_of_document: "Cedula",
        document_number: "V-22345678",
        document_issued_at: Date.new(2020, 1, 15),
        document_expires_at: Date.new(2030, 1, 15),
        full_name: "Juan Perez",
        email: "juan.perez@email.com",
        primary_phone: "04161234567",
        secondary_phone: "04261234567"
      }

      second_params = first_params.merge(
        document_number: "V-87654321",
        email: "juan.duplicado@email.com"
      )

      created_client = service.create_client(first_params)
      expect(created_client).to be_persisted

      duplicated_client = service.create_client(second_params)
      expect(duplicated_client).to be_persisted
    end

    it "falla si se intenta cambiar tipo de persona en actualizacion" do
      client = service.create_client(
        type_of_person: "Natural",
        type_of_document: "Cedula",
        document_number: "V-33445566",
        document_issued_at: Date.today,
        document_expires_at: Date.today + 1.year,
        full_name: "Cambio Persona",
        email: "cambio.persona@test.com",
        primary_phone: "04141234573"
      )

      result = service.update_client(client.id, type_of_person: "Juridica")
      expect(result.errors[:type_of_person]).to include("no se puede modificar una vez creado")
      expect(Client.find(client.id).type_of_person).to eq("Natural")
    end

    it "falla si se intenta cambiar tipo de documento en actualizacion" do
      client = service.create_client(
        type_of_person: "Natural",
        type_of_document: "Cedula",
        document_number: "V-44556677",
        document_issued_at: Date.today,
        document_expires_at: Date.today + 1.year,
        full_name: "Cambio Documento",
        email: "cambio.documento@test.com",
        primary_phone: "04141234574"
      )

      result = service.update_client(client.id, type_of_document: "Pasaporte")
      expect(result.errors[:type_of_document]).to include("no se puede modificar una vez creado")
      expect(Client.find(client.id).type_of_document).to eq("Cedula")
    end

    it "falla si el nombre contiene numeros" do
      invalid_params = {
        type_of_person: "Natural",
        type_of_document: "Cedula",
        document_number: "V-99887766",
        document_issued_at: Date.new(2021, 5, 10),
        document_expires_at: Date.new(2031, 5, 10),
        full_name: "Juan Perez 123",
        email: "juan123@email.com",
        primary_phone: "04121234567"
      }

      result = service.create_client(invalid_params)
      expect(result.errors[:full_name]).to include("solo puede contener letras, espacios, acentos y la letra ñ")
    end
  end
end
