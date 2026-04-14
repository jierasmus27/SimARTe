class Admin::UsersController < Admin::BaseController
  def index
    @services = Service.order(:name)
    @q = params[:q].to_s.strip
    users_scope = policy_scope(User).search(@q).includes(:services, subscriptions: :service).order(:email)
    @pagy, @users = pagy(users_scope)
    @user = User.new
  end

  def create
    @services = Service.order(:name)
    @q = params[:q].to_s.strip
    @user = User.new(user_create_params)
    authorize @user

    if @user.save
      @new_row_user = @user
      @user = User.new
      assign_index_pagy_for_stream
    end

    respond_to do |format|
      format.turbo_stream { render :create }
      format.html do
        if @new_row_user
          redirect_to admin_users_path(**index_redirect_params), notice: "User created successfully."
        else
          redirect_to admin_users_path(**index_redirect_params), alert: @user.errors.full_messages.to_sentence
        end
      end
    end
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

  def index_redirect_params
    { q: @q.presence, page: params[:page].presence }.compact
  end

  def assign_index_pagy_for_stream
    users_scope = policy_scope(User).search(@q).includes(:services, subscriptions: :service).order(:email)
    page = (params[:page].presence || 1).to_i
    @pagy, = pagy(users_scope, page: page)
  end

  def user_create_params
    params.expect(user: [ :email, :first_name, :last_name, :role, :password, :password_confirmation ])
  end

  def user_params
    params.expect(user: [ :role ])
  end
end
