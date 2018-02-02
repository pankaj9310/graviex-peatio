module Admin
  module Withdraws
    class PoseidonsController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Poseidon'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_poseidons = @poseidons.with_aasm_state(:accepted).order("id DESC")
        @all_poseidons = @poseidons.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @poseidon.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @poseidon.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
