module Private::Withdraws
  class GraviosController < ::Private::Withdraws::BaseController
    include ::Withdraws::Withdrawable
  end
end
