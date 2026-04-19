# frozen_string_literal: true

module Mutations
  class CreateUser < Mutations::BaseMutation
    argument :email, String, required: true
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: false

    def resolve(email:, first_name:, last_name:, password:, password_confirmation:)
      authorize User.new, :create?

      user = User.create!(email:, first_name:, last_name:, password:, password_confirmation:)
      { user: }
    rescue ActiveRecord::RecordInvalid => e
      raise GraphQL::ExecutionError, "Invalid input: #{e.message}"
    end
  end
end
