module Private
  class TwoFactorSigninController < BaseController
    before_action :auth_activated!
    before_action :two_factor_activated!

    def index
    end

    def new
    end

    def create
    end

    def show
      # enable
      if two_factor_locked?(expired_at: 1)
        session[:return_to] = request.original_url
        redirect_to two_factors_path
      else
        current_user.app_two_factor.set_require_signin
        redirect_to settings_path, notice: t('.enabled')
      end
    end

    def edit
      # disable
      if two_factor_locked?(expired_at: 1)
        session[:return_to] = request.original_url
        redirect_to two_factors_path
      else
        current_user.app_two_factor.reset_require_signin
        redirect_to settings_path, alert: t('.disabled')
      end
    end

    def update
    end

    def destroy
    end

    def unbind
    end

  end
end
