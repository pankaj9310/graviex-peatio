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
      @phc_proof   = Proof.current :phc
      @xgc_proof   = Proof.current :xgc
      @dev_proof   = Proof.current :dev
      @pbs_proof   = Proof.current :pbs
      @din_proof   = Proof.current :din
      @adv_proof   = Proof.current :adv
      @dv7_proof   = Proof.current :dv7
      @jew_proof   = Proof.current :jew
      @argo_proof   = Proof.current :argo
      @esco_proof   = Proof.current :esco
      @neet_proof   = Proof.current :neet
      @xylo_proof   = Proof.current :xylo
      @steep_proof   = Proof.current :steep
      @bitg_proof   = Proof.current :bitg
      @crft_proof   = Proof.current :crft
      @env_proof   = Proof.current :env
      @sng_proof   = Proof.current :sng
      @nyc_proof   = Proof.current :nyc
      @zoc_proof   = Proof.current :zoc
      @btcz_proof   = Proof.current :btcz
      @ytn_proof   = Proof.current :ytn
      @yic_proof   = Proof.current :yic
      #proof

      if current_user
        @btc_account = current_user.accounts.with_currency(:btc).first
        @gio_account = current_user.accounts.with_currency(:gio).first
        @doge_account = current_user.accounts.with_currency(:doge).first
        @ltc_account = current_user.accounts.with_currency(:ltc).first
        @eth_account = current_user.accounts.with_currency(:eth).first
        @psd_account = current_user.accounts.with_currency(:psd).first
        @phc_account = current_user.accounts.with_currency(:phc).first
        @xgc_account = current_user.accounts.with_currency(:xgc).first
        @dev_account = current_user.accounts.with_currency(:dev).first
        @pbs_account = current_user.accounts.with_currency(:pbs).first
        @din_account = current_user.accounts.with_currency(:din).first
        @adv_account = current_user.accounts.with_currency(:adv).first
        @dv7_account = current_user.accounts.with_currency(:dv7).first
        @jew_account = current_user.accounts.with_currency(:jew).first
        @argo_account = current_user.accounts.with_currency(:argo).first
        @esco_account = current_user.accounts.with_currency(:esco).first
        @neet_account = current_user.accounts.with_currency(:neet).first
        @xylo_account = current_user.accounts.with_currency(:xylo).first
        @steep_account = current_user.accounts.with_currency(:steep).first
        @bitg_account = current_user.accounts.with_currency(:bitg).first
        @crft_account = current_user.accounts.with_currency(:crft).first
        @env_account = current_user.accounts.with_currency(:env).first
        @sng_account = current_user.accounts.with_currency(:sng).first
        @nyc_account = current_user.accounts.with_currency(:nyc).first
        @zoc_account = current_user.accounts.with_currency(:zoc).first
        @btcz_account = current_user.accounts.with_currency(:btcz).first
        @ytn_account = current_user.accounts.with_currency(:ytn).first
        @yic_account = current_user.accounts.with_currency(:yic).first
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
