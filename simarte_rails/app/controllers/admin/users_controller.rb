class Admin::UsersController < Admin::BaseController
  def index
    @services = Service.order(:name)
    @users = User.includes(:services, subscriptions: :service).order(:email)
  end
end
