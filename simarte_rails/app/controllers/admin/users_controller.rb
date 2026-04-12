class Admin::UsersController < Admin::BaseController
  def index
    @services = Service.order(:name)
    @users = policy_scope(User).includes(:services, subscriptions: :service).order(:email)
  end

  def update
    user = authorize User.find(params.expect(:id))

    unless user.update(user_params)
      redirect_to admin_users_path, alert: user.errors.full_messages.to_sentence
      return
    end

    @user = User.includes(:services, subscriptions: :service).find(user.id)
    @services = Service.order(:name)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to admin_users_path, notice: "User updated successfully" }
    end
  end

  private

  def user_params
    params.expect(user: [ :role ])
  end
end
