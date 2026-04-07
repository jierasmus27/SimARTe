class Users::SessionsController < Devise::SessionsController
  # Devise has no `index`; ApplicationController's `verify_policy_scoped, only: :index`
  # would reference a non-existent action on this controller.
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  # Allow POST while a stale non-admin session exists so credentials can be replaced;
  # otherwise Devise redirects with "You are already signed in." before `create` runs.
  skip_before_action :require_no_authentication, only: [:create]

  layout "login"

  def create
    attrs = sign_in_params
    self.resource = resource_class.find_for_authentication(email: attrs[:email])

    unless resource&.valid_password?(attrs[:password])
      redirect_to root_path, alert: "Incorrect username or password."
      return
    end

    unless resource.admin?
      sign_out(resource_name) if user_signed_in?
      redirect_to root_path, alert: "Incorrect username or password."
      return
    end

    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # Devise 5 calls this with keyword args; a bare `*` signature raises ArgumentError on Ruby 3.
  def respond_to_on_destroy(non_navigational_status: :no_content)
    redirect_to after_sign_out_path_for(resource_name), status: Devise.responder.redirect_status
  end
end
