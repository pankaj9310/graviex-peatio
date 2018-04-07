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

        begin

          if withdraw.currency == 'eth' || withdraw.currency == 'mix' || withdraw.currency == 'aka'
            balance = open("#{withdraw.channel.currency_obj.rest}/cgi-bin/total.cgi").read.rstrip.to_f
            raise Account::BalanceError, 'Insufficient coins' if balance < withdraw.sum

            fee = [withdraw.fee.to_f || withdraw.channel.try(:fee) || 0.0005, 0.1].min

            local_nonce = 0
            if withdraw.channel.currency_obj.code == "aka"
              CoinRPC[withdraw.currency].personal_unlockAccount(withdraw.channel.currency_obj.base_account, "", 0)
              # get nonce
              local_nonce = CoinRPC[withdraw.currency].eth_getTransactionCount(withdraw.channel.currency_obj.base_account, "latest").to_i(16)
            else
              CoinRPC[withdraw.currency].personal_unlockAccount(withdraw.channel.currency_obj.base_account, "", "0x30")
              # get nonce
              local_nonce = CoinRPC[withdraw.currency].parity_nextNonce(withdraw.channel.currency_obj.base_account).to_i(16)
            end

            # calc amount
            gas_limit = withdraw.channel.currency_obj.gas_limit
            gas_price = withdraw.channel.currency_obj.gas_price
            #local_amount = (withdraw.amount * 1e18).to_i - (gas_price * gas_limit)

            txid = CoinRPC[withdraw.currency].eth_sendTransaction(from: withdraw.channel.currency_obj.base_account, to: withdraw.fund_uid, gas: "0x" + gas_limit.to_s(16), gasPrice: "0x" + gas_price.to_s(16), nonce: "0x" + local_nonce.to_s(16), value: "0x" + ((withdraw.amount * 1e18).to_i.to_s(16)))
          else
            balance = CoinRPC[withdraw.currency].getbalance.to_d
            raise Account::BalanceError, 'Insufficient coins' if balance < withdraw.sum

            fee = [withdraw.fee.to_f || withdraw.channel.try(:fee) || 0.0005, 0.1].min

            # CoinRPC[withdraw.currency].settxfee fee
            @amount = (withdraw.amount*100000000.0).round / 100000000.0
            txid = CoinRPC[withdraw.currency].sendtoaddress withdraw.channel.currency_obj.base_secret, withdraw.fund_uid, @amount.to_f
          end
  
          withdraw.whodunnit('Worker::WithdrawCoin') do
            withdraw.update_column :txid, txid

            # withdraw.succeed! will start another transaction, cause
            # Account after_commit callbacks not to fire
            withdraw.succeed
            withdraw.save!
          end
        rescue => ex
          Rails.logger.info "[error]: " + ex.message

          withdraw.whodunnit('Worker::WithdrawCoin') do
            withdraw.update_column :explanation, ex.message
            withdraw.save!
          end

        end

      end
    end

  end
end
