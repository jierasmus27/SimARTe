# frozen_string_literal: true

module Resolvers
  class User < GraphQL::Schema::Resolver
    include GraphqlPundit

    type Types::UserType, null: true
    argument :id, ID, required: true

    def resolve(id:)
      record = context.schema.object_from_id(id, context)
      return nil unless record.is_a?(::User)

      authorize record, :show?
      record
    end
  end
end
