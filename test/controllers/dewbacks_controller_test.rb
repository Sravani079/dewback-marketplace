require "test_helper"

class DewbacksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "testuser#{SecureRandom.hex(4)}@example.com",
      name: "test1",
      password: "password"
    )
    @dewback = Dewback.create!(
      title: "Sample Dewback", color: "Green", size: "Medium", max_speed: "Moderate",
      max_load: "Heavy", food_requirements: "High", price: 2500, quantity: 1,
      description: "Test dewback"
    )
    @owner = Owner.create!(user: @user, dewback: @dewback)
    sign_in @user
  end

  test "should get my_dewbacks when signed in" do
    get my_dewbacks_url
    assert_response :success
    assert_select "h2.card-title", text: @dewback.title
  end
end
