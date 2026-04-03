class AdminController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    return render(Login::PageComponent.new, layout: "login") unless user_signed_in?
  end
end
