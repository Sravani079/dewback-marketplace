require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = User.create!(
      email: "admin_#{SecureRandom.hex(4)}@example.com",
      name: "Admin User",
      password: "password",
      admin: true
    )

    @user = User.create!(
      email: "user_#{SecureRandom.hex(4)}@example.com",
      name: "Regular User",
      password: "password",
      admin: false
    )

    sign_in @admin
  end

  test "admin should see index" do
    get admin_users_url
    assert_response :success
    assert_match @user.email, response.body
  end

  test "admin should promote user" do
    patch promote_admin_user_url(@user)
    assert_redirected_to admin_users_url
    @user.reload
    assert @user.admin?
  end

  test "non-admin should be blocked from index" do
    sign_out @admin
    sign_in @user
    get admin_users_url
    assert_redirected_to root_url
    follow_redirect!
    assert_match "Access denied", response.body
  end

  test "non-admin should be blocked from promote" do
    sign_out @admin
    sign_in @user
    patch promote_admin_user_url(@admin)
    assert_redirected_to root_url
    follow_redirect!
    assert_match "Access denied", response.body
  end
end
