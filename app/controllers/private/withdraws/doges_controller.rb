module Private::Withdraws
  class DogesController < ::Private::Withdraws::BaseController
    include ::Withdraws::Withdrawable
  end
end
