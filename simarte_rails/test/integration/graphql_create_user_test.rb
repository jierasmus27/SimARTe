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

  test "createUser succeeds after admin logs in via JSON and sends Bearer token" do
    post "/users/sign_in",
      params: {
        user: {
          email: @admin.email,
          password: "password123"
        }
      },
      headers: {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      },
      as: :json

    assert_response :success
    auth_header = response.headers["Authorization"]
    assert auth_header.present?, "expected JWT in Authorization response header after JSON sign-in"
    assert auth_header.start_with?("Bearer "), auth_header

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
end
