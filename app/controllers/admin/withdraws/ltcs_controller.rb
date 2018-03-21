module Admin
  module Withdraws
    class LtcsController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Ltc'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24 * 3)
        @one_ltcs = @ltcs.with_aasm_state(:almost_done).order("id DESC")
        @all_ltcs = @ltcs.without_aasm_state(:almost_done).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @ltc.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @ltc.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
