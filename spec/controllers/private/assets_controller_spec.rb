require 'spec_helper'

describe Private::AssetsController do
  let(:member) { create :member }
  before { session[:member_id] = member.id }

  context "logged in user visit" do
    describe "GET /exchange_assets" do
      before { get :index }

      it { should respond_with :ok }
    end
  end

  context "non-login user visit" do
    before { session[:member_id] = nil }

    describe "GET /exchange_assets" do
      before { get :index }

      it { should respond_with :ok }
      it { expect(assigns(:btc_account)).to be_nil }
      it { expect(assigns(:gio_account)).to be_nil }
      it { expect(assigns(:doge_account)).to be_nil }
      it { expect(assigns(:ltc_account)).to be_nil }
      it { expect(assigns(:psd_account)).to be_nil }
      it { expect(assigns(:phc_account)).to be_nil }
      it { expect(assigns(:xgc_account)).to be_nil }
      it { expect(assigns(:dev_account)).to be_nil }
      it { expect(assigns(:pbs_account)).to be_nil }
      it { expect(assigns(:din_account)).to be_nil }
      it { expect(assigns(:adv_account)).to be_nil }
      it { expect(assigns(:dv7_account)).to be_nil }
      it { expect(assigns(:jew_account)).to be_nil }
      it { expect(assigns(:argo_account)).to be_nil }
      it { expect(assigns(:esco_account)).to be_nil }
      it { expect(assigns(:neet_account)).to be_nil }
      it { expect(assigns(:xylo_account)).to be_nil }
      it { expect(assigns(:steep_account)).to be_nil }
      it { expect(assigns(:bitg_account)).to be_nil }
      it { expect(assigns(:crft_account)).to be_nil }
      it { expect(assigns(:env_account)).to be_nil }
      it { expect(assigns(:sng_account)).to be_nil }
      it { expect(assigns(:nyc_account)).to be_nil }
      it { expect(assigns(:zoc_account)).to be_nil }
      it { expect(assigns(:btcz_account)).to be_nil }
      it { expect(assigns(:ytn_account)).to be_nil }
      it { expect(assigns(:yic_account)).to be_nil }
      it { expect(assigns(:tlp_account)).to be_nil }
      it { expect(assigns(:pwc_account)).to be_nil }
      it { expect(assigns(:shnd_account)).to be_nil }
      it { expect(assigns(:lmn_account)).to be_nil }
      it { expect(assigns(:kec_account)).to be_nil }
      it { expect(assigns(:abs_account)).to be_nil }
      it { expect(assigns(:suppo_account)).to be_nil }
      it { expect(assigns(:linda_account)).to be_nil }
      it { expect(assigns(:hight_account)).to be_nil }
      it { expect(assigns(:bls_account)).to be_nil }
      it { expect(assigns(:tokc_account)).to be_nil }
      it { expect(assigns(:elp_account)).to be_nil }
      it { expect(assigns(:zex_account)).to be_nil }
      it { expect(assigns(:rlc_account)).to be_nil }
      it { expect(assigns(:lucky_account)).to be_nil }
      it { expect(assigns(:ich_account)).to be_nil }
      it { expect(assigns(:mmb_account)).to be_nil }
      it { expect(assigns(:pnx_account)).to be_nil }
      it { expect(assigns(:mix_account)).to be_nil }
      #it

    end
  end

end
