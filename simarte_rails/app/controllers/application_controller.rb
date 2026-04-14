class ApplicationController < ActionController::Base
  include ::Pagy::Backend
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_authorized, if: :verify_authorized_needed?
  after_action :verify_policy_scoped, if: :verify_policy_scoped_needed?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_user!, unless: :devise_controller?

  protected

  def user_not_authorized
    respond_to do |format|
      format.html { redirect_to root_path, alert: "You are not authorized to perform this action." }
      format.turbo_stream { head :forbidden }
    end
  end

  def authenticate_user!
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    stored = stored_location_for(resource)
    return stored if stored.present?

    resource.admin? ? admin_users_path : root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def verify_authorized_needed?
    action_name != "index"
  end

  def verify_policy_scoped_needed?
    action_name == "index"
  end
end
