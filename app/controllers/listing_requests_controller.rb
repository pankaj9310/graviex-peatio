class ListingRequestsController < ApplicationController

  def show
    @listing_request = ListingRequest.find(params[:id])
  end

  def new
    @listing_request = ListingRequest.new
  end

  def edit
    @listing_request = ListingRequest.find(params[:id])
  end

  def create
    Rails.logger.info params.to_json
    @listing_request = ListingRequest.new(listing_request_params)
    @listing_request.save

    if !simple_captcha_valid?
      flash.now[:alert] = 'Invalid captcha'
      render :action => 'edit', :id => @listing_request
      return
    end

    if listing_request_params && listing_request_params_present
      address  = CoinRPC[:gio].getnewaddress("payment", "")
      Rails.logger.info "Listing req new address " + address
      @listing_request.address = address
      @listing_request.save
      @listing_request.approve!
      flash.now[:notice] = t('.notice')
      render :action => 'show', :id => @listing_request
    else
      flash.now[:alert] = t('.alert')
      render :action => 'edit', :id => @listing_request
    end
  end

  def update
    @listing_request = ListingRequest.find(params[:id])
   
    if @listing_request.aasm_state != "void"
      render nothing: true
      return
    end

    @listing_request.update_attributes(listing_request_params)

    if !simple_captcha_valid?
      flash.now[:alert] = 'Invalid captcha'
      render :action => 'edit', :id => @listing_request
      return
    end

    if listing_request_params && listing_request_params_present
      address  = CoinRPC[:gio].getnewaddress("payment", "")
      Rails.logger.info "Listing req new address " + address
      @listing_request.address = address
      @listing_request.update address: address
      @listing_request.approve!
      flash.now[:notice] =  t('.notice')
      render :action => 'show', :id => @listing_request
    else
      flash.now[:alert] =  t('.alert')
      render :action => 'edit', :id => @listing_request
    end
  end

  private

  def listing_request_params
    params.require(:listing_request).permit(:ticker, :name, :algo, :codebase, :source, :be, :home, :btt, :lang, :email, :discord, :twitter, :reddit, :facebook, :telegram, :comment, :secret)
  end

  def listing_request_params_present
    r = params[:listing_request]
    r[:ticker].present? && r[:name].present? && r[:algo].present? && r[:codebase].present? && r[:source].present? && r[:be].present? && r[:btt].present? && 
      r[:lang].present? && r[:email].present? && r[:secret].present?
  end

end
