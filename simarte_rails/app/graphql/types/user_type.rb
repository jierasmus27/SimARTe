# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :role, String, null: false
    field :subscriptions, [ Types::SubscriptionType ], null: false

    def subscriptions
      object.subscriptions.includes(:service)
    end
  end
end
