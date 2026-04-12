class Admin::UsersController < Admin::BaseController
  def index
    @services = Service.order(:name)
    @users = policy_scope(User).includes(:services, subscriptions: :service).order(:email)
  end

  def update
    @services = Service.order(:name)
    @user = User.find(params.expect(:id))
    permitted = user_params
    @user.assign_attributes(permitted)
    authorize @user

    if @user.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            helpers.dom_id(@user, :table_row),
            partial: "admin/users/table_row",
            locals: { user: @user, services: @services }
          )
        end
        format.html { redirect_to admin_users_path }
      end
    else
      redirect_to admin_users_path, alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def user_params
    params.expect(user: [ :role ])
  end
end
