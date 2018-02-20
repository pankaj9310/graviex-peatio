module Worker
  class WithdrawCoin

    def process(payload, metadata, delivery_info)
      payload.symbolize_keys!

      Withdraw.transaction do
        withdraw = Withdraw.lock.find payload[:id]

        return unless withdraw.processing?

        withdraw.whodunnit('Worker::WithdrawCoin') do
          withdraw.call_rpc
          withdraw.save!
        end
      end

      Withdraw.transaction do
        withdraw = Withdraw.lock.find payload[:id]

        Rails.logger.info "[Withdraw]: " + withdraw.currency

        return unless withdraw.almost_done?

        if withdraw.currency == 'eth'
          balance = open("#{withdraw.channel.currency_obj.rest}/cgi-bin/total.cgi").read.rstrip.to_f
          raise Account::BalanceError, 'Insufficient coins' if balance < withdraw.sum

          fee = [withdraw.fee.to_f || withdraw.channel.try(:fee) || 0.0005, 0.1].min
          CoinRPC[withdraw.currency].personal_unlockAccount(withdraw.channel.currency_obj.base_account, "", "0x30")
          # get nonce
          local_nonce = CoinRPC["eth"].parity_nextNonce(withdraw.channel.currency_obj.base_account).to_i(16)

          # calc amount
          gas_limit = withdraw.channel.currency_obj.gas_limit
          gas_price = withdraw.channel.currency_obj.gas_price
          #local_amount = (withdraw.amount * 1e18).to_i - (gas_price * gas_limit)

          txid = CoinRPC["eth"].eth_sendTransaction(from: withdraw.channel.currency_obj.base_account, to: withdraw.fund_uid, gas: "0x" + gas_limit.to_s(16), gasPrice: "0x" + gas_price.to_s(16), nonce: "0x" + local_nonce.to_s(16), value: "0x" + ((withdraw.amount * 1e18).to_i.to_s(16)))
        else
          balance = CoinRPC[withdraw.currency].getbalance.to_d
          raise Account::BalanceError, 'Insufficient coins' if balance < withdraw.sum

          fee = [withdraw.fee.to_f || withdraw.channel.try(:fee) || 0.0005, 0.1].min

          # CoinRPC[withdraw.currency].settxfee fee
          @amount = (withdraw.amount*100000000.0).round / 100000000.0
          txid = CoinRPC[withdraw.currency].sendtoaddress withdraw.fund_uid, @amount.to_f
        end

        withdraw.whodunnit('Worker::WithdrawCoin') do
          withdraw.update_column :txid, txid

          # withdraw.succeed! will start another transaction, cause
          # Account after_commit callbacks not to fire
          withdraw.succeed
          withdraw.save!
        end

      end
    end

  end
end
