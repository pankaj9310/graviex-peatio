module Private
  module Deposits
    class DogesController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlCoinable
    end
  end
end
