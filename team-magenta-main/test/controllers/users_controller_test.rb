require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "testuser_#{SecureRandom.hex(4)}@example.com",
      name: "Test User",
      password: "password"
    )
    sign_in @user
  end

  test "should get edit profile page" do
    get edit_profile_url  # route: resource :profile, controller: 'users'
    assert_response :success
    assert_match "Edit", response.body
  end

  test "should update profile with valid params" do
    patch profile_url, params: {
      user: {
        email: "updated_#{SecureRandom.hex(3)}@example.com",
        name: "Updated Name"
      }
    }
    assert_redirected_to root_url
    follow_redirect!
    assert_match "Profile updated", response.body
  end

  test "should not update profile with invalid params" do
    patch profile_url, params: {
      user: {
        email: "",  # invalid email
        name: ""
      }
    }
    assert_response :success
    assert_match "Edit", response.body  # renders edit again
  end
end
