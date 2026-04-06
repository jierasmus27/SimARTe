class Admin::UsersController < Admin::BaseController
  def index
    @services = Service.order(:name)
    @users = User.includes(:services).order(:email)
  end
end
