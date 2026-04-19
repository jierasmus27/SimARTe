# frozen_string_literal: true

class GraphqlController < ApplicationController
  # JSON API + Bearer JWT: no CSRF session; unverified requests get an empty session.
  protect_from_forgery with: :null_session

  # Auth0 access tokens (not Devise session); Pundit uses context[:current_user] in resolvers.
  skip_before_action :authenticate_user!, only: [ :execute ]
  before_action :authenticate_with_auth0_bearer!, only: [ :execute ]
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

  def current_user
    @graphql_current_user
  end

  private

  def authenticate_with_auth0_bearer!
    request.session_options[:skip] = true

    token = bearer_token
    if token.blank?
      render_auth_required
      return
    end

    claims = Auth0AccessTokenVerifier.new.verify(token)
    user = User.find_or_sync_from_auth0(claims)

    if user.nil?
      render_auth_required
      return
    end

    @graphql_current_user = user
  rescue Auth0AccessTokenVerifier::InvalidToken
    render_auth_required
  rescue Auth0AccessTokenVerifier::ConfigurationError => e
    Rails.logger.error("[GraphQL] Auth0 configuration error: #{e.message}")
    render json: { errors: [ { message: "Authentication misconfigured" } ] }, status: :internal_server_error
  end

  def bearer_token
    request.headers["Authorization"].to_s[%r{\ABearer (.+)\z}, 1]
  end

  def render_auth_required
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
