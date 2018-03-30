class ListingRequest < ActiveRecord::Base
  extend Enumerize

  include AASM

  STATE = [:void, :approved]
  enumerize :aasm_state, in: STATE, scope: true

  enumerize :codebase, in: {bitcoin: 0, litecoin: 1, dash: 2, pivx: 3, cryptonote:4, lisk: 5}

  aasm :whiny_transitions => false do
    state :void, initial: true
    state :approved, after_commit: :request_approved

    event :approve do
      transitions from: :void, to: :approved
    end
  end

  def request_approved
    Rails.logger.info "[listing_request]: request_approved"
  end

  #validates_presence_of :ticker, :name, :algo, :codebase, :source, :be, :btt, :lang, :email, :secret
end
