module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[username phone address city postal_code province_id])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update,
                                        keys: %i[username phone address city postal_code province_id])
    end

    def after_sign_up_path_for(_resource)
      root_path
    end
  end
end
