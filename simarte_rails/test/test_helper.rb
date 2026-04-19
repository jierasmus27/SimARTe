ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "devise/test/integration_helpers"
require_relative "support/auth0_jwt_test_helper"

# Keep JWT verification deterministic in tests, regardless of host/container ENV.
ENV["AUTH0_DOMAIN"] = Auth0JwtTestHelper::DOMAIN
ENV["AUTH0_AUDIENCE"] = Auth0JwtTestHelper::AUDIENCE
Auth0AccessTokenVerifier.jwks_override = Auth0JwtTestHelper.jwks_set

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
