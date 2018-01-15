module Deposits
  module CtrlCoinable
    extend ActiveSupport::Concern

    def gen_address
      account = current_user.get_account(channel.currency)
      @address = account.payment_addresses.create currency: account.currency
      @address.gen_address 

    end

  end
end
