# frozen_string_literal: true

require "openssl"
require "jwt"

# RSA keypair + JWKS used to mint Auth0-shaped JWTs in tests (no network).
module Auth0JwtTestHelper
  module_function

  DOMAIN = "simarte-test.auth0.com"
  AUDIENCE = "https://simarte-test-api.example/"
  ISSUER = "https://#{DOMAIN}/"

  def rsa_keypair
    @rsa_keypair ||= OpenSSL::PKey::RSA.new(2048)
  end

  def jwks_set
    @jwks_set ||= JWT::JWK::Set.new(JWT::JWK.new(rsa_keypair, kid: "test-kid-1"))
  end

  def issue_access_token(sub:, email:, email_verified: true)
    now = Time.now.to_i
    payload = {
      "iss" => ISSUER,
      "sub" => sub,
      "aud" => AUDIENCE,
      "iat" => now,
      "exp" => now + 3600,
      "email" => email,
      "email_verified" => email_verified
    }
    JWT.encode(payload, rsa_keypair, "RS256", { kid: "test-kid-1" })
  end
end
