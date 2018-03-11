class Ticket < ActiveRecord::Base
  include AASM
  include AASM::Locking
  acts_as_readable on: :created_at

  after_commit :send_notification, on: [:create]

  validates_with TicketValidator

  has_many :comments
  belongs_to :author, class_name: 'Member', foreign_key: 'author_id'

  scope :open, -> { where(aasm_state: :open) }
  scope :close, -> { where(aasm_state: :closed) }

  aasm whiny_transitions: false do
    state :open
    state :closed

    event :close do
      transitions from: :open, to: :closed
    end

    event :reopen do
      transitions from: :closed, to: :open
    end
  end

  def title_for_display(n = 60)
    "[" + id.to_s + "] " + (title.blank? ? content.truncate(n) : title.truncate(n))
  end

  def title_for_display_user(n = 60)
    title.blank? ? content.truncate(n) + " - [" + id.to_s + "]" : title.truncate(n) + " - [" + id.to_s + "]"
  end

  def reply_by_admin?
    last_comment = Comment.where('ticket_id = ?', self.id).order("id desc").limit(1).first
    #Rails.logger.info last_comment.to_json

    if last_comment != nil and Member.where(email: Member.admins).pluck(:id).include? last_comment.author_id
      return true
    end

    return false
  end

  def reply_by_admin_pending?
    last_comment = Comment.where('ticket_id = ?', self.id).order("id desc").limit(1).first
    #Rails.logger.info last_comment.to_json

    if last_comment != nil and Member.where(email: Member.admins).pluck(:id).include? last_comment.author_id and last_comment.is_pending
      return true
    end

    return false
  end

  private

  def send_notification
    TicketMailer.author_notification(self.id).deliver
    TicketMailer.admin_notification(self.id).deliver
  end

end
