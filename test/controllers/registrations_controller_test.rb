require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
  end

  test "create with valid params" do
    assert_difference "User.count", 1 do
      post registration_path, params: {
        user: {
          email_address: "new@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with duplicate email" do
    existing = users(:one)

    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: existing.email_address,
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "#error_explanation"
  end

  test "create with invalid params" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: "invalid",
          password: "short",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "#error_explanation"
  end
end
