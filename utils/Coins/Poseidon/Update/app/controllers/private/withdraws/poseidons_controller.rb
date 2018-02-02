module Private
  module Withdraws
    class PoseidonsController < ::Private::Withdraws::BaseController
      include ::Withdraws::Withdrawable
    end
  end
end
