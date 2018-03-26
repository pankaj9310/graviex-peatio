class Dividend < ActiveRecord::Base
  extend Enumerize

  include AASM

  STATE = [:void, :accepted]
  enumerize :aasm_state, in: STATE, scope: true

  has_one :product, :foreign_key => :id, :primary_key => :product_id
  belongs_to :member

  has_many :intraday_dividends, :order => 'created_at DESC'
  has_many :daily_dividends, :order => 'created_at DESC'

  aasm :whiny_transitions => false do
    state :void, initial: true
    state :accepted, after_commit: :contract_accepted

    event :accept do
      before :is_allowed
      transitions from: :void, to: :accepted
    end

    event :revoke do
      before :is_allowed
      transitions from: :accepted, to: :void
    end
  end

  def is_allowed
    if self.updated_at == nil or self.updated_at.to_i - self.created_at.to_i <= 1 
      return true
    end

    if Time.now.to_i - self.updated_at.to_i < 72 * 60 * 60
      raise "Contract switching will be available in " + (72.0 - (Time.now.to_i - self.updated_at.to_i) / 3600.0).round(2).to_s + " hours"
    end
    
    return true
  end

  def is_accepted
    if self.aasm_state == 'accepted'
      return true
    end
    return false
  end

  def asset
    return member.accounts.with_currency(product.asset).first
  end

  def interest
    return member.accounts.with_currency(product.interest).first
  end

  def intraday_list
    list = []

    intraday_dividends.each do |hour|
      list.push(hour)
    
      if list.length >= 24
        return list
      end
    end    

    return list
  end

  def daily_list
    list = []

    daily_dividends.each do |day|
      list.push(day)

      if list.length >= 60
        return list
      end
    end

    return list
  end

  def interest_total
    return daily_dividends.sum(:profit)
  end

  def interest_intraday
    return intraday_dividends.sum(:profit)
  end

  def contract_accepted
    Rails.logger.info "[dividends]: contract_accepted"
  end

  def contract_revoked
    Rails.logger.info "[dividends]: contract_revoked"
  end

end
