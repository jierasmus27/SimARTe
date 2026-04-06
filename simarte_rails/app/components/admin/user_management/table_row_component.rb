class Admin::UserManagement::TableRowComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private

  def service_input_checked?(service_name:)
    signed_up_for_service?(service_name: service_name) ? "checked" : ""
  end

  def signed_up_for_service?(service_name:)
    user_services.exists?(name: service_name)
  end

  def user_services
    @_user_services ||= @user.services
  end
end
