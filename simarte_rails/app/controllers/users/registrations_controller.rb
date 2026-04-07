class Users::RegistrationsController < Devise::RegistrationsController
  # Same as Users::SessionsController — no `index` action for Pundit's scoped callback.
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  before_action :configure_permitted_parameters, only: %i[create update]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
