# frozen_string_literal: true

require "net/http"
require "jwt"

# Verifies Auth0-issued JWT access tokens (RS256 + JWKS). Used by GraphQL Bearer auth.
class Auth0AccessTokenVerifier
  class Error < StandardError; end
  class InvalidToken < Error; end
  class ConfigurationError < Error; end

  # Set in test to a JWT::JWK::Set built from a local RSA key (no HTTP to Auth0).
  class_attribute :jwks_override, instance_accessor: false

  JWKS_CACHE_KEY = "auth0_jwks_json"
  JWKS_TTL = 12.hours

  def initialize
    @domain = self.class.auth0_domain
    @audience = self.class.auth0_audience
  end

  def verify(token_string)
    raise InvalidToken if token_string.blank?
    raise ConfigurationError, "AUTH0_DOMAIN / credentials auth0.domain missing" if @domain.blank?
    raise ConfigurationError, "AUTH0_AUDIENCE / credentials auth0.audience missing" if @audience.blank?

    jwks = self.class.jwks_override || load_jwks_from_cache_or_remote
    options = {
      algorithms: [ "RS256" ],
      jwks: jwks,
      verify_aud: true,
      aud: @audience,
      verify_iss: true,
      iss: issuer
    }
    payload, = JWT.decode(token_string, nil, true, options)
    payload
  rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::InvalidAudError, JWT::InvalidIssuerError
    raise InvalidToken
  end

  def self.auth0_domain
    ENV["AUTH0_DOMAIN"].presence || Rails.application.credentials.dig(:auth0, :domain)
  end

  def self.auth0_audience
    ENV["AUTH0_AUDIENCE"].presence || Rails.application.credentials.dig(:auth0, :audience)
  end

  private

  def issuer
    "https://#{@domain}/"
  end

  def load_jwks_from_cache_or_remote
    json = Rails.cache.fetch(JWKS_CACHE_KEY, expires_in: JWKS_TTL, race_condition_ttl: 10.seconds) do
      fetch_jwks_json_from_auth0
    end
    keys = JSON.parse(json)["keys"]
    JWT::JWK::Set.new(keys)
  end

  def fetch_jwks_json_from_auth0
    uri = URI("https://#{@domain}/.well-known/jwks.json")
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new(uri)
      res = http.request(req)
      unless res.is_a?(Net::HTTPSuccess)
        Rails.logger.error("[Auth0] JWKS fetch failed: HTTP #{res.code}")
        raise InvalidToken
      end

      res.body
    end
  rescue InvalidToken
    raise
  rescue StandardError => e
    Rails.logger.error("[Auth0] JWKS fetch failed: #{e.class}: #{e.message}")
    raise InvalidToken
  end
end
