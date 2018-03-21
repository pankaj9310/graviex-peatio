module Admin
  module Withdraws
    class DogesController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Doge'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24 * 3)
        @one_doges = @doges.with_aasm_state(:almost_done).order("id DESC")
        @all_doges = @doges.without_aasm_state(:almost_done).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @doge.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @doge.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
