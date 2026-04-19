# frozen_string_literal: true

module Types
  class SubscriptionType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: false
    field :service_id, ID, null: false
    field :service_name, String, null: false

    def service_name
      object.service.name
    end
  end
end
