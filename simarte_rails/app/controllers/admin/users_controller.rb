class Admin::UsersController < Admin::BaseController
  def index
    @services = Service.order(:name)
    @users = policy_scope(User).includes(:services, subscriptions: :service).order(:email)
  end
end
