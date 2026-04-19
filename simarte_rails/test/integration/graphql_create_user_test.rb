# frozen_string_literal: true

require "test_helper"

class GraphqlCreateUserTest < ActionDispatch::IntegrationTest
  CREATE_USER_MUTATION = <<~GQL
    mutation CreateUser($input: CreateUserInput!) {
      createUser(input: $input) {
        user {
          id
          email
          firstName
          lastName
          role
        }
      }
    }
  GQL

  USER_QUERY = <<~GQL
    query User($id: ID!) {
      user(id: $id) {
        id
        email
        firstName
        lastName
      }
    }
  GQL

  setup do
    @admin = users(:one)
    @new_email = "graphql_created_#{SecureRandom.hex(4)}@example.com"
  end

  test "createUser returns 401 without JWT" do
    post "/graphql",
      params: {
        query: CREATE_USER_MUTATION,
        variables: {
          input: {
            email: @new_email,
            firstName: "Graph",
            lastName: "Created",
            password: "password123",
            passwordConfirmation: "password123",
            clientMutationId: "1"
          }
        }
      },
      as: :json

    assert_response :unauthorized
    body = JSON.parse(response.body)
    assert_equal "Authentication required", body.dig("errors", 0, "message")
  end

  test "createUser succeeds with valid Auth0-shaped Bearer token" do
    token = Auth0JwtTestHelper.issue_access_token(
      sub: @admin.auth0_sub,
      email: @admin.email
    )
    auth_header = "Bearer #{token}"

    assert_difference -> { User.count }, 1 do
      post "/graphql",
        params: {
          query: CREATE_USER_MUTATION,
          variables: {
            input: {
              email: @new_email,
              firstName: "Graph",
              lastName: "Created",
              password: "password123",
              passwordConfirmation: "password123",
              clientMutationId: "2"
            }
          }
        },
        headers: {
          "Authorization" => auth_header,
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        as: :json
    end

    assert_response :success
    body = JSON.parse(response.body)
    assert_nil body["errors"], body.inspect

    user_json = body.dig("data", "createUser", "user")
    assert_equal @new_email, user_json["email"]
    assert_equal "Graph", user_json["firstName"]
    assert_equal "Created", user_json["lastName"]
    assert_equal "user", user_json["role"]
  end

  test "user query returns another user when caller is admin" do
    token = Auth0JwtTestHelper.issue_access_token(
      sub: @admin.auth0_sub,
      email: @admin.email
    )
    auth_header = "Bearer #{token}"
    other = users(:two)

    post "/graphql",
      params: {
        query: USER_QUERY,
        variables: { id: other.to_gid_param }
      },
      headers: {
        "Authorization" => auth_header,
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      },
      as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_nil body["errors"], body.inspect
    assert_equal other.email, body.dig("data", "user", "email")
  end
end
