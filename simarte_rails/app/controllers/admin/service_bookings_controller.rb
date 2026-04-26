class Admin::ServiceBookingsController < Admin::BaseController
  def index
    @users = policy_scope(User).order(:email)
    @selected_user_id = params[:user_id].presence
    @selected_date = params[:date].presence
    @availability_slots = []
  end

  def show
    @users = policy_scope(User).order(:email)
    @selected_user_id = params[:user_id].presence
    @selected_date = params[:date].presence
    @availability_slots = []
  end
end
