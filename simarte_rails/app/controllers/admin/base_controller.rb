class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :require_admin!

  private

  def require_admin!
    return if current_user.admin?

    redirect_to root_path, alert: "Incorrect username or password."
  end
end
