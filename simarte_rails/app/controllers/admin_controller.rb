class AdminController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    return render(Login::PageComponent.new(alert: flash[:alert]), layout: "login") unless user_signed_in?

    redirect_to admin_root_path
  end
end
