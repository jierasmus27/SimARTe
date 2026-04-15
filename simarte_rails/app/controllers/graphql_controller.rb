# frozen_string_literal: true

class GraphqlController < ApplicationController
  # JSON API + Bearer JWT: no CSRF session; unverified requests get an empty session.
  protect_from_forgery with: :null_session

  # Devise JWT only (no cookie session); Pundit runs in resolvers/mutations, not here.
  skip_before_action :authenticate_user!, only: [ :execute ]
  before_action :require_jwt_authenticated_user!, only: [ :execute ]
  skip_after_action :verify_authorized, only: [ :execute ]
  skip_after_action :verify_policy_scoped, only: [ :execute ]

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = { current_user: current_user }
    result = SimarteRailsSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def require_jwt_authenticated_user!
    # Ignore session cookies so only Authorization: Bearer <token> is used (devise-jwt).
    request.session_options[:skip] = true
    return if user_signed_in?

    render json: { errors: [ { message: "Authentication required" } ] }, status: :unauthorized
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: 500
  end
end
