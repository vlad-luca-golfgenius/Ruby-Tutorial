require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid sign up info" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: {
        user: {
          name: "test",
          email: "invalid@email",
          password: "12345",
          password_confirmation: "123",
        }
      }
    end
    assert_template "users/new"
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end

  test "valid sign up info" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          name: "test",
          email: "test@gmail.com",
          password: "12345678",
          password_confirmation: "12345678"
        }
      }
    end
    follow_redirect!
    assert_template "users/show"
    assert_select "div.alert-success"

  end
end
