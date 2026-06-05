module ClientsHelper
  def client_modal_payload(client)
    {
      id: client.id,
      full_name: client.full_name,
      type_of_person: client.type_of_person,
      type_of_document: client.type_of_document,
      document_number: client.document_number,
      document_issued_at: client.document_issued_at&.strftime("%d-%m-%Y").presence || "-",
      document_expires_at: client.document_expires_at&.strftime("%d-%m-%Y").presence || "-",
      email: client.email,
      primary_phone: client.primary_phone,
      secondary_phone: client.secondary_phone.presence || "-",
      created_at: l(client.created_at),
      edit_path: edit_client_path(client)
    }.to_json
  end
end
