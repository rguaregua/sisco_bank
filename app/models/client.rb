class Client < ApplicationRecord
  # Excluye registros eliminados de forma logica por defecto.
  default_scope { where(deleted_at: nil) }

  PERSON_TYPES = ["Natural", "Juridica"].freeze
  DOC_TYPES = ["Cedula", "Pasaporte", "RIF"].freeze
  ALLOWED_DOC_TYPES_BY_PERSON = {
    "Natural" => ["Cedula", "Pasaporte"],
    "Juridica" => ["RIF"]
  }.freeze
  INVALID_DOC_ERROR_BY_PERSON = {
    "Natural" => "inválido para Persona Natural",
    "Juridica" => "debe ser RIF para Persona Jurídica"
  }.freeze
  RIF_FORMAT = /\A[JGVEP]-\d{8}-\d\z/
  CEDULA_FORMAT = /\A[VE]-\d{6,8}\z/

  before_validation :normalize_email
  before_validation :normalize_phone_numbers
  before_validation :normalize_document_number
  before_validation :normalize_full_name

  validates :type_of_person, presence: true, inclusion: { in: PERSON_TYPES }
  validates :type_of_document, presence: true, inclusion: { in: DOC_TYPES }
  validates :document_number, presence: true, uniqueness: { case_sensitive: false }
  validates :document_issued_at, :document_expires_at, presence: true
  validates :full_name,
            presence: true,
            format: { with: /\A[[:alpha:]ÁÉÍÓÚáéíóúÑñ]+(?: [[:alpha:]ÁÉÍÓÚáéíóúÑñ]+)*\z/ }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :primary_phone,
            presence: true,
            format: { with: /\A0\d{10}\z/, message: :invalid_format }
  validates :secondary_phone,
            allow_blank: true,
            format: { with: /\A0\d{10}\z/, message: :invalid_format }

  validate :expiration_date_cannot_be_prior_to_issue_date
  validate :document_type_matches_person_type
  validate :rif_number_format_for_juridica
  validate :cedula_number_format_for_natural
  validate :person_and_document_type_immutable_on_update, on: :update

  private

  def expiration_date_cannot_be_prior_to_issue_date
    return unless document_issued_at.present? && document_expires_at.present?
    return unless document_expires_at <= document_issued_at

    errors.add(:document_expires_at, :invalid_date)
  end

  def document_type_matches_person_type
    return unless type_of_person.present? && type_of_document.present?

    allowed_types = ALLOWED_DOC_TYPES_BY_PERSON[type_of_person]
    return if allowed_types.blank? || allowed_types.include?(type_of_document)

    errors.add(:type_of_document, INVALID_DOC_ERROR_BY_PERSON.fetch(type_of_person, "no corresponde al tipo de persona"))
  end

  def rif_number_format_for_juridica
    return unless type_of_person == "Juridica" && type_of_document == "RIF"
    return if document_number.present? && document_number.match?(RIF_FORMAT)

    errors.add(:document_number, "debe tener formato RIF valido (Ej: J-12345678-9)")
  end

  def cedula_number_format_for_natural
    return unless type_of_person == "Natural" && type_of_document == "Cedula"
    return if document_number.present? && document_number.match?(CEDULA_FORMAT)

    errors.add(:document_number, "debe tener formato de cédula valido (Ej: V-12345678)")
  end

  def person_and_document_type_immutable_on_update
    errors.add(:type_of_person, "no se puede modificar una vez creado") if will_save_change_to_type_of_person?
    errors.add(:type_of_document, "no se puede modificar una vez creado") if will_save_change_to_type_of_document?
  end

  def normalize_email
    self.email = email.to_s.strip.downcase if email.present?
  end

  def normalize_phone_numbers
    self.primary_phone = normalize_phone(primary_phone)
    self.secondary_phone = normalize_phone(secondary_phone)
  end

  def normalize_document_number
    self.document_number = document_number.to_s.strip.upcase if document_number.present?
  end

  def normalize_full_name
    return unless full_name.present?

    self.full_name = full_name.to_s.strip.gsub(/\s+/, " ")
  end

  def normalize_phone(value)
    cleaned = value.to_s.gsub(/\D/, "")
    cleaned.presence
  end
end
