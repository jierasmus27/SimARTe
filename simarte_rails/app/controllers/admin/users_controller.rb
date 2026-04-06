class Admin::UsersController < Admin::BaseController
  def index
    @users = User.includes(:services).order(:email)
  end
end
