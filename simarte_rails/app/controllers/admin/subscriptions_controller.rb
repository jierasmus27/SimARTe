# frozen_string_literal: true

class Admin::SubscriptionsController < Admin::BaseController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized, except: %i[create destroy]

  def create
    user = User.find(params.expect(:user_id))
    service = Service.find(params.expect(:service_id))

    subscription = user.subscriptions.build(service: service)

    authorize subscription

    if subscription&.save
      redirect_back fallback_location: admin_users_path, status: :see_other
    else
      redirect_back fallback_location: admin_users_path, alert: subscription.errors.full_messages.to_sentence, status: :see_other
    end
  end

  def destroy
    subscription = authorize Subscription.find(params.expect(:id))
    subscription.destroy!
    redirect_back fallback_location: admin_users_path, status: :see_other
  end
end
