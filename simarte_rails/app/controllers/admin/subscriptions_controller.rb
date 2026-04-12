# frozen_string_literal: true

class Admin::SubscriptionsController < Admin::BaseController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized, except: %i[create destroy]

  def create
    @services = Service.order(:name)
    user = User.find(params.expect(:user_id))
    service = Service.find(params.expect(:service_id))

    subscription = user.subscriptions.build(service: service)

    authorize subscription

    if subscription.save
      respond_to do |format|
        format.turbo_stream { render_row_replace(user) }
        format.html { redirect_back fallback_location: admin_users_path, status: :see_other }
      end
    else
      respond_to do |format|
        format.turbo_stream { render_subscription_error(user, subscription) }
        format.html do
          redirect_back fallback_location: admin_users_path, alert: subscription.errors.full_messages.to_sentence, status: :see_other
        end
      end
    end
  end

  def destroy
    subscription = authorize Subscription.find(params.expect(:id))
    user = subscription.user
    subscription.destroy!

    @services = Service.order(:name)
    respond_to do |format|
      format.turbo_stream { render_row_replace(user) }
      format.html { redirect_back fallback_location: admin_users_path, status: :see_other }
    end
  end

  private

  def render_row_replace(user)
    row_user = User.includes(:subscriptions, subscriptions: :service).find(user.id)
    render turbo_stream: turbo_stream.replace(
      helpers.dom_id(row_user, :table_row),
      partial: "admin/users/table_row",
      locals: { user: row_user, services: @services }
    )
  end

  def render_subscription_error(user, subscription)
    row_user = User.includes(:subscriptions, subscriptions: :service).find(user.id)
    render turbo_stream: [
      turbo_stream.replace(
        helpers.dom_id(row_user, :table_row),
        partial: "admin/users/table_row",
        locals: { user: row_user, services: @services }
      ),
      turbo_stream.append(
        "admin_flash_messages",
        partial: "admin/flash_alert",
        locals: { message: subscription.errors.full_messages.to_sentence }
      )
    ]
  end
end
