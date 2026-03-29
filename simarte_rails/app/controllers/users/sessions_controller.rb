class Users::SessionsController < Devise::SessionsController
  layout false

  def respond_to_on_destroy
    redirect_to root_path, status: :see_other
  end
end
