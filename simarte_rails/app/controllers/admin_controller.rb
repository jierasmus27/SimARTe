class AdminController < ApplicationController
  # Root admin controller only has `show`, not `index`. Inheriting
  # `verify_policy_scoped, only: :index` from ApplicationController would
  # reference a non-existent action here — skip Pundit verification entirely.
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  skip_before_action :authenticate_user!, only: :show

  def show
    unless user_signed_in?
      return render(Login::PageComponent.new(alert: flash[:alert]), layout: "login")
    end

    if current_user.admin?
      redirect_to admin_users_path
    else
      sign_out(:user)
      redirect_to root_path, alert: "Incorrect username or password."
    end
  end
end
