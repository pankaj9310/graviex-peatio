class WebhooksController < ApplicationController
	before_action :auth_anybody!
	skip_before_filter :verify_authenticity_token
	def tx
		if params[:type] == "transaction" && params[:hash].present?
			AMQPQueue.enqueue(:deposit_coin, txid: params[:hash], channel_key: "satoshi")
			render :json => { :status => "queued" }
		end
	end
	def eth
		if params[:type] == "transaction" && params[:hash].present?
			AMQPQueue.enqueue(:deposit_coin, txid: params[:hash], channel_key: "ether")
			render :json => { :status => "queued" }
		end
	end
		def eth
		if params[:type] == "transaction" && params[:hash].present?
			AMQPQueue.enqueue(:deposit_coin, txid: params[:hash], channel_key: "touristcoin")
			render :json => { :status => "queued" }
		end
	end
        def mix
                if params[:type] == "transaction" && params[:hash].present?
                        AMQPQueue.enqueue(:deposit_coin, txid: params[:hash], channel_key: "mixcoin")
                        render :json => { :status => "queued" }
                end
        end
        def aka
                if params[:type] == "transaction" && params[:hash].present?
                        AMQPQueue.enqueue(:deposit_coin, txid: params[:hash], channel_key: "akromacoin")
                        render :json => { :status => "queued" }
                end
        end
end

