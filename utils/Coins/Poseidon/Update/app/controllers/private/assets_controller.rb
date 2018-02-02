module Private
  class AssetsController < BaseController
    skip_before_action :auth_member!, only: [:index]

    def index
      @btc_proof   = Proof.current :btc
      @gio_proof   = Proof.current :gio
      @doge_proof   = Proof.current :doge
      @ltc_proof   = Proof.current :ltc
      @eth_proof   = Proof.current :eth
      @psd_proof   = Proof.current :psd
      #proof

      if current_user
        @btc_account = current_user.accounts.with_currency(:btc).first
        @gio_account = current_user.accounts.with_currency(:gio).first
        @doge_account = current_user.accounts.with_currency(:doge).first
        @ltc_account = current_user.accounts.with_currency(:ltc).first
        @eth_account = current_user.accounts.with_currency(:eth).first
        @psd_account = current_user.accounts.with_currency(:psd).first
        #account
      end
    end

    def partial_tree
      account    = current_user.accounts.with_currency(params[:id]).first
      @timestamp = Proof.with_currency(params[:id]).last.timestamp
      @json      = account.partial_tree.to_json.html_safe
      respond_to do |format|
        format.js
      end
    end

  end
end
