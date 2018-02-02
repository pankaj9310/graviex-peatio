module Admin
  module Deposits
    class PoseidonsController < ::Admin::Deposits::BaseController
      load_and_authorize_resource :class => '::Deposits::Poseidon'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24 * 365)
        @poseidons = @poseidons.includes(:member).
          where('created_at > ?', start_at).
          order('id DESC').page(params[:page]).per(20)
      end

      def update
        @poseidon.accept! if @poseidon.may_accept?
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
