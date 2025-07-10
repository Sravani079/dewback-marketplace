require "test_helper"

class TradeMarketControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "trader#{SecureRandom.hex(4)}@example.com",
      name: "Trader",
      password: "password"
    )

    sign_in @user

    @dewback = Dewback.create!(
      title: "Tradable Dewback",
      color: "Green",
      size: "Large",
      max_speed: "Moderate",
      max_load: "Heavy",
      food_requirements: "Moderate",
      price: 1500,
      quantity: 1,
      description: "Test dewback for trade"
    )

    Owner.create!(
      user: @user,
      dewback: @dewback,
      available_for_trade: true
    )
  end

  test "should get index and show available dewbacks" do
    get trade_market_url
    assert_response :success
    assert_match "Tradable Dewback", response.body
  end

  test "should redirect index if not logged in" do
    sign_out @user
    get trade_market_url
    assert_redirected_to new_user_session_path
  end
  
end
