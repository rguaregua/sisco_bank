class Client < ApplicationRecord
  # Excluye registros eliminados de forma logica por defecto.
  default_scope { where(deleted_at: nil) }

  PERSON_TYPES = ["Natural", "Juridica"].freeze
  DOC_TYPES = ["Cedula", "Pasaporte", "RIF"].freeze

  validates :type_of_person, presence: true, inclusion: { in: PERSON_TYPES }
  validates :type_of_document, presence: true, inclusion: { in: DOC_TYPES }
  validates :document_number, presence: true, uniqueness: { case_sensitive: false }
  validates :document_issued_at, :document_expires_at, presence: true
  validates :full_name, presence: true, format: { with: /\A[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+\z/ }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :primary_phone, presence: true, format: { with: /\A0\d+\z/, message: :invalid_format }
  validates :secondary_phone, allow_blank: true, format: { with: /\A0\d+\z/, message: :invalid_format }

  validate :expiration_date_cannot_be_prior_to_issue_date
  validate :document_type_matches_person_type

  private

  def expiration_date_cannot_be_prior_to_issue_date
    return unless document_issued_at.present? && document_expires_at.present?
    return unless document_expires_at <= document_issued_at

    errors.add(:document_expires_at, :invalid_date)
  end

  def document_type_matches_person_type
    return unless type_of_person.present? && type_of_document.present?

    if type_of_person == "Natural" && !["Cedula", "Pasaporte"].include?(type_of_document)
      errors.add(:type_of_document, "invalido para Persona Natural")
    elsif type_of_person == "Juridica" && type_of_document != "RIF"
      errors.add(:type_of_document, "debe ser RIF para Persona Juridica")
    end
  end
end
