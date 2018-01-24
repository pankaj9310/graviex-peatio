module Private::Withdraws
  class EthersController < ::Private::Withdraws::BaseController
    include ::Withdraws::Withdrawable
  end
end
