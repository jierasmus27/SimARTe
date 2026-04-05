class Users::SessionsController < Devise::SessionsController
  layout "login"

  def create
    attrs = sign_in_params
    self.resource = resource_class.find_for_authentication(email: attrs[:email])

    if resource&.valid_password?(attrs[:password])
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      redirect_to root_path, alert: "Incorrect username or password."
    end
  end

  # Devise 5 calls this with keyword args; a bare `*` signature raises ArgumentError on Ruby 3.
  def respond_to_on_destroy(non_navigational_status: :no_content)
    redirect_to after_sign_out_path_for(resource_name), status: Devise.responder.redirect_status
  end
end
