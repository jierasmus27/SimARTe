class Admin::UsersController < Admin::BaseController
  def index
    @services = Service.order(:name)
    @users = policy_scope(User).includes(:services, subscriptions: :service).order(:email)
  end

  def update
    user = authorize User.find(params.expect(:id))
    user.update(user_params)
    redirect_to admin_users_path, notice: "User updated successfully"
  end

  private

  def user_params
    params.expect(:user).permit(:role)
  end
end
