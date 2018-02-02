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
      #it

    end
  end

end
