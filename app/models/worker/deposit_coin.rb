module Worker
  class DepositCoin

    def process(payload, metadata, delivery_info)
      payload.symbolize_keys!

      sleep 0.1 # nothing result without sleep by query gettransaction api

      channel_key = payload[:channel_key]
      txid = payload[:txid]

      channel = DepositChannel.find_by_key(channel_key)
      if channel.currency_obj.proto == 'ETH'
        raw  = get_raw_eth channel, txid
        raw.symbolize_keys!
        deposit_eth!(channel, txid, 1, raw)
      else
        raw  = get_raw channel, txid
        raw[:details].each_with_index do |detail, i|
          detail.symbolize_keys!
          deposit!(channel, txid, i, raw, detail)
        end
      end
    end

    def deposit_eth!(channel, txid, txout, raw)
      ActiveRecord::Base.transaction do
        unless PaymentAddress.where(currency: channel.currency_obj.id, address: raw[:to]).first
          Rails.logger.info "Deposit address not found, skip. txid: #{txid}, txout: #{txout}, address: #{raw[:to]}, amount: #{raw[:value].to_i(16) / 1e18}"
          return
        end
        return if PaymentTransaction::Normal.where(txid: txid, txout: txout).first
        confirmations = CoinRPC[channel.currency_obj.code].eth_blockNumber.to_i(16) - raw[:blockNumber].to_i(16)
        tx = PaymentTransaction::Normal.create! \
        txid: txid,
        txout: txout,
        address: raw[:to],
        amount: (raw[:value].to_i(16) / 1e18).to_d,
        confirmations: confirmations,
        receive_at: Time.now.to_datetime,
        currency: channel.currency

        deposit = channel.kls.create! \
        payment_transaction_id: tx.id,
        txid: tx.txid,
        txout: tx.txout,
        amount: tx.amount,
        member: tx.member,
        account: tx.account,
        currency: tx.currency,
        confirmations: tx.confirmations

        deposit.submit!
        #deposit.accept! 
      end
    rescue
      Rails.logger.error "Failed to deposit: #{$!}"
      Rails.logger.error "txid: #{txid}, txout: #{txout}, detail: #{raw.inspect}"
      Rails.logger.error $!.backtrace.join("\n")
    end

    def deposit!(channel, txid, txout, raw, detail)
      #return if detail[:account] != "payment" || detail[:category] != "receive"
      return if detail[:category] != "receive"

      ActiveRecord::Base.transaction do
        if channel.key == "gravio" && ListingRequest.where(address: detail[:address]).first
          return if PaymentTransaction::Normal.where(txid: txid, txout: txout).first

          tx = PaymentTransaction::Normal.create! \
          txid: txid,
          txout: txout,
          address: detail[:address],
          amount: detail[:amount].to_s.to_d,
          confirmations: raw[:confirmations],
          receive_at: Time.at(raw[:time]).to_datetime,
          currency: channel.currency,
          aasm_state: "confirmed"
          request = ListingRequest.where(address: detail[:address]).first
          if request.amount
            request.amount = request.amount + detail[:amount].to_f
          else
            request.amount = detail[:amount].to_f
          end
          request.update amount: request.amount, aasm_state: "approved"
          #request.approve!
          return
        end
        unless PaymentAddress.where(currency: channel.currency_obj.id, address: detail[:address]).first
          Rails.logger.info "Deposit address not found, skip. txid: #{txid}, txout: #{txout}, address: #{detail[:address]}, amount: #{detail[:amount]}"
          return
        end

        return if PaymentTransaction::Normal.where(txid: txid, txout: txout).first

        tx = PaymentTransaction::Normal.create! \
        txid: txid,
        txout: txout,
        address: detail[:address],
        amount: detail[:amount].to_s.to_d,
        confirmations: raw[:confirmations],
        receive_at: Time.at(raw[:time]).to_datetime,
        currency: channel.currency

        deposit = channel.kls.create! \
        payment_transaction_id: tx.id,
        txid: tx.txid,
        txout: tx.txout,
        amount: tx.amount,
        member: tx.member,
        account: tx.account,
        currency: tx.currency,
        confirmations: tx.confirmations

        deposit.submit!
      end
    rescue
      Rails.logger.error "Failed to deposit: #{$!}"
      Rails.logger.error "txid: #{txid}, txout: #{txout}, detail: #{detail.inspect}"
      Rails.logger.error $!.backtrace.join("\n")
    end

    def get_raw(channel, txid)
      channel.currency_obj.api.gettransaction(txid)
    end

    def get_raw_eth(channel, txid)
      raw = CoinRPC[channel.currency_obj.code].eth_getTransactionByHash(txid)
      if raw == nil
        raw = CoinRPC[channel.currency_obj.code].eth_getTransaction(txid)
      end
      return raw
    end
  end
end

