module Admin
  module Withdraws
    class GraviosController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Gravio'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24 * 3)
        @one_gravios = @gravios.with_aasm_state(:almost_done).order("id DESC")
        @all_gravios = @gravios.without_aasm_state(:almost_done).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @gravio.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @gravio.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
