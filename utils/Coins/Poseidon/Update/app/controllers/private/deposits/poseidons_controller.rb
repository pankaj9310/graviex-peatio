module Private
  module Deposits
    class PoseidonsController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlCoinable
    end
  end
end
