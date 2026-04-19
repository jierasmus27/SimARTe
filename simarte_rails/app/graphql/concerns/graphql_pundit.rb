# frozen_string_literal: true

# Pundit helpers for GraphQL resolvers and mutations. Use +context[:current_user]+
# (set in GraphqlController) as +pundit_user+.
module GraphqlPundit
  extend ActiveSupport::Concern

  # Pundit::Authorization defines +pundit_user+ as +current_user+ after our concern's
  # instance methods are applied, so we +prepend+ this module to win in method lookup.
  module PunditUserFromContext
    def pundit_user
      context[:current_user]
    end
  end

  included do
    include Pundit::Authorization
    prepend PunditUserFromContext
  end
end
