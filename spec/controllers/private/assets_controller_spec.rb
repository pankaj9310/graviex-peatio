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
      it { expect(assigns(:kreds_account)).to be_nil }
      it { expect(assigns(:bkt_account)).to be_nil }
      it { expect(assigns(:snx_account)).to be_nil }
      it { expect(assigns(:giro_account)).to be_nil }
      it { expect(assigns(:onex_account)).to be_nil }
      it { expect(assigns(:pushi_account)).to be_nil }
      it { expect(assigns(:vrt_account)).to be_nil }
      it { expect(assigns(:zaca_account)).to be_nil }
      it { expect(assigns(:xhm_account)).to be_nil }
      it { expect(assigns(:xar_account)).to be_nil }
      it { expect(assigns(:rupx_account)).to be_nil }
      it { expect(assigns(:frm_account)).to be_nil }
      it { expect(assigns(:men_account)).to be_nil }
      it { expect(assigns(:mun_account)).to be_nil }
      it { expect(assigns(:onemc_account)).to be_nil }
      it { expect(assigns(:alp_account)).to be_nil }
      it { expect(assigns(:zel_account)).to be_nil }
      it { expect(assigns(:amx_account)).to be_nil }
      it { expect(assigns(:pew_account)).to be_nil }
      it { expect(assigns(:fsc_account)).to be_nil }
      it { expect(assigns(:sln_account)).to be_nil }
      it { expect(assigns(:usx_account)).to be_nil }
      it { expect(assigns(:bsx_account)).to be_nil }
      it { expect(assigns(:eot_account)).to be_nil }
      it { expect(assigns(:xap_account)).to be_nil }
      it { expect(assigns(:miac_account)).to be_nil }
      it { expect(assigns(:kc_account)).to be_nil }
      it { expect(assigns(:arhm_account)).to be_nil }
      it { expect(assigns(:olmp_account)).to be_nil }
      it { expect(assigns(:onz_account)).to be_nil }
      it { expect(assigns(:agn_account)).to be_nil }
      it { expect(assigns(:crz_account)).to be_nil }
      it { expect(assigns(:enix_account)).to be_nil }
      it { expect(assigns(:snc_account)).to be_nil }
      it { expect(assigns(:quaz_account)).to be_nil }
      it { expect(assigns(:scriv_account)).to be_nil }
      it { expect(assigns(:ethf_account)).to be_nil }
      it { expect(assigns(:arepa_account)).to be_nil }
      it { expect(assigns(:sub1x_account)).to be_nil }
      it { expect(assigns(:cheese_account)).to be_nil }
      it { expect(assigns(:jiyo_account)).to be_nil }
      it { expect(assigns(:pyro_account)).to be_nil }
      it { expect(assigns(:roe_account)).to be_nil }
      it { expect(assigns(:citr_account)).to be_nil }
      it { expect(assigns(:xen_account)).to be_nil }
      it { expect(assigns(:edl_account)).to be_nil }
      it { expect(assigns(:cru_account)).to be_nil }
      it { expect(assigns(:ndc_account)).to be_nil }
      it { expect(assigns(:zls_account)).to be_nil }
      it { expect(assigns(:proton_account)).to be_nil }
      #it

    end
  end

end
