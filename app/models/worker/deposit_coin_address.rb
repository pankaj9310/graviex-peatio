module Worker
  class DepositCoinAddress

    def process(payload, metadata, delivery_info)
      payload.symbolize_keys!

      payment_address = PaymentAddress.find payload[:payment_address_id]
      return if payment_address.address.present?

      account = Account.where('id = ?', payment_address.account_id).first
      member = Member.where('id = ?', account.member_id).first

      currency = payload[:currency]
      if currency == 'eth' || currency == 'mix' || currency == 'aka'
        address  = CoinRPC[currency].personal_newAccount("")
      else
        address  = CoinRPC[currency].getnewaddress("payment", member.email + member.id.to_s)
      end

      if payment_address.update address: address
        ::Pusher["private-#{payment_address.account.member.sn}"].trigger_async('deposit_address', { type: 'create', attributes: payment_address.as_json})

        payment_address.account.update default_address: address
      end
    end

  end
end
