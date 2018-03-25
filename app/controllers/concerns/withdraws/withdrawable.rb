module Withdraws
  module Withdrawable
    extend ActiveSupport::Concern

    included do
      before_filter :fetch
    end

    def create
      @withdraw = model_kls.new(withdraw_params)

      @verified = current_user.id_document_verified?
      @local_sum = params[:withdraw][:sum]

      if !@local_sum
        render text: I18n.t('private.withdraws.create.amount_empty_error'), status: 403
        return
      end

      if !@verified && channel.currency_obj.withdraw_limit < @local_sum
        render text: I18n.t('private.withdraws.create.unverified_withdraw_limit_error', limit: channel.currency_obj.withdraw_limit), status: 403
        return
      end

      sql = "select created_at as result from withdraws where member_id = #{current_user.id} and currency = #{channel.currency_obj.id} order by id desc limit 1";
      res = ActiveRecord::Base.connection.exec_query(sql).first
      last_withdraw = DateTime.parse('2018-01-01 00:00:00')
      if res != nil
        last_withdraw = res['result']
      end

      @current_date_time = DateTime.now
      Rails.logger.info "[Withdraw]: last = " + last_withdraw.to_i.to_s + ", current = " + @current_date_time.to_i.to_s + ", diff = " + (@current_date_time.to_i - last_withdraw.to_i).to_s + ", sql = " + sql

      if @current_date_time.to_i - last_withdraw.to_i < 40
        render text: 'Withdraw threshold violated', status: 403
        return
      end

      @current_date = DateTime.now.to_date
      @current_date_time = DateTime.now
      @current_withdraws = Withdraw.with_aasm_state(:done).where(member_id: current_user.id, currency: @channel.currency_obj.id, created_at: @current_date...@current_date_time).pluck(:amount)
      @withdraw_amount = @current_withdraws.sum

      if !@withdraw_amount
        @withdraw_amount = 0
      end

      #Rails.logger.info "withdraw_day_limit " + channel.currency_obj.withdraw_day_limit.to_s + " db_amount " + @withdraw_amount.to_s

      if !@verified && channel.currency_obj.withdraw_day_limit < @withdraw_amount
        render text: I18n.t('private.withdraws.create.unverified_withdraw_day_limit_error', limit: channel.currency_obj.withdraw_day_limit), status: 403
        return
      end

      if two_factor_auth_verified?
        if @withdraw.save
          @withdraw.submit!
          # we emulate admins transitions - accept
          @withdraw.accept!
          # ... and process for automated withdrawal processing
          @withdraw.process!
          render nothing: true
        else
          render text: @withdraw.errors.full_messages.join(', '), status: 403
          return
        end
      else
        render text: I18n.t('private.withdraws.create.two_factors_error'), status: 403
        return
      end
    end

    def destroy
      Withdraw.transaction do
        @withdraw = current_user.withdraws.find(params[:id]).lock!
        @withdraw.cancel
        @withdraw.save!
      end
      render nothing: true
    end

    private

    def fetch
      @account = current_user.get_account(channel.currency)
      @model = model_kls
      @fund_sources = current_user.fund_sources.with_currency(channel.currency)
      @assets = model_kls.without_aasm_state(:submitting).where(member: current_user).order(:id).reverse_order.limit(10)
    end

    def withdraw_params
      params[:withdraw][:currency] = channel.currency
      params[:withdraw][:member_id] = current_user.id
      params.require(:withdraw).permit(:fund_uid, :member_id, :currency, :sum)
    end

  end
end
