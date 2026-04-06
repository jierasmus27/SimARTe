# frozen_string_literal: true

class Admin::SubscriptionsController < Admin::BaseController
  def create
    user = User.find(params.expect(:user_id))
    service = Service.find(params.expect(:service_id))

    subscription = user.subscriptions.build(service: service)
    if subscription.save
      redirect_back fallback_location: admin_root_path, status: :see_other
    else
      redirect_back fallback_location: admin_root_path, alert: subscription.errors.full_messages.to_sentence, status: :see_other
    end
  end

  def destroy
    subscription = Subscription.find(params.expect(:id))
    subscription.destroy!
    redirect_back fallback_location: admin_root_path, status: :see_other
  end
end
