module Private
  class DividendsController < BaseController
    layout 'dividends'

    before_action :auth_activated!
    before_action :two_factor_activated!

    def index
      @product = current_user.dividend.product
      @dividend = current_user.dividend
      @asset = current_user.dividend.asset
      @interest = current_user.dividend.interest
      @interest_intraday = current_user.dividend.interest_intraday
      @interest_total = current_user.dividend.interest_total
      @intraday_list = current_user.dividend.intraday_list
      @daily_list = current_user.dividend.daily_list

      gon.jbuilder
    end

    def accept_agreement
      begin
        current_user.dividend.accept!
      rescue => ex
        render :json => { :errors => ex.message }, :status => 403 
        return
      end
      render nothing: true
    end

    def revoke_agreement
      begin
        current_user.dividend.revoke!
      rescue => ex
        render :json => { :errors => ex.message }, :status => 403
        return
      end  
    render nothing: true
    end

  end
end

