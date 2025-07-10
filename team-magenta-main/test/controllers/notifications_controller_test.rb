require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "notify@example.com", name: "test1", password: "password")
    sign_in @user
  end

  test "should get index" do
    get notifications_url
    assert_response :success
  end

  test "should mark notification as read" do
    notification = Notification.create!(user: @user, message: "Test", read: false)

    patch mark_as_read_notification_url(notification)
    assert_redirected_to notifications_url
    assert notification.reload.read?
  end
end
