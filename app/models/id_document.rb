class IdDocument < ActiveRecord::Base
  extend Enumerize
  include AASM
  include AASM::Locking

  has_one :id_document_file, class_name: 'Asset::IdDocumentFile', as: :attachable
  accepts_nested_attributes_for :id_document_file

  has_one :id_bill_file, class_name: 'Asset::IdBillFile', as: :attachable
  accepts_nested_attributes_for :id_bill_file

  belongs_to :member

  validates_presence_of :name, :id_document_type, :id_document_number, :id_document_file, :id_bill_file,  allow_nil: true
  validates_uniqueness_of :member

  enumerize :id_document_type, in: {id_card: 0, passport: 1, driver_license: 2}
  enumerize :id_bill_type,     in: {bank_statement: 0, tax_bill: 1, selfie_id: 2}

  alias_attribute :full_name, :name

  before_update :verify_bill_type

  paginates_per 15

  aasm do
    state :unverified, initial: true
    state :verifying
    state :verified,    after_commit: [:send_mail_approved]
    state :unverified,  after_commit: [:send_mail_rejected]

    event :submit do
      transitions from: :unverified, to: :verifying
    end

    event :approve do
      transitions from: [:unverified, :verifying],  to: :verified
    end

    event :reject do
      transitions from: [:verifying, :verified, :unverified],  to: :unverified
    end
  end

  def verify_bill_type
    self.id_bill_type = "selfie_id"
    #Rails.logger.info self.to_json
  end

  def is_verified?
    if self.aasm_state == 'verified'
      return true
    end
    return false
  end

  def send_mail_rejected
    MemberMailer.auth_rejected(member.id).deliver
  end

  def send_mail_approved
    MemberMailer.auth_approved(member.id).deliver
  end

end
