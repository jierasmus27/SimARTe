class Users::SessionsController < Devise::SessionsController
  # Devise has no `index`; ApplicationController's `verify_policy_scoped, only: :index`
  # would reference a non-existent action on this controller.
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  layout "login"

  def create
    if request.format.json?
      render json: {
        error: "API clients must authenticate with Auth0. This endpoint only accepts HTML sign-in."
      }, status: :unprocessable_entity
      return
    end

    attrs = sign_in_params
    self.resource = resource_class.find_for_authentication(email: attrs[:email])

    unless resource&.valid_password?(attrs[:password])
      respond_to_failed_sign_in
      return
    end

    unless resource.admin?
      sign_out(resource_name) if user_signed_in?
      respond_to_failed_sign_in
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

  private

  def respond_to_failed_sign_in
    respond_to do |format|
      format.html { redirect_to root_path, alert: "Incorrect username or password." }
    end
  end
end
