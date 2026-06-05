class ClientSerializer < ActiveModel::Serializer
  attributes :id, :type_of_person, :type_of_document, :document_number,
             :document_issued_at, :document_expires_at, :full_name,
             :email, :primary_phone, :secondary_phone, :created_at

  def document_issued_at
    object.document_issued_at&.strftime("%d-%m-%Y")
  end

  def document_expires_at
    object.document_expires_at&.strftime("%d-%m-%Y")
  end
end