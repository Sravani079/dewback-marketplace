require "test_helper"

class MyDewbacksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "test#{SecureRandom.hex(4)}@example.com",
      name: "test1",
      password: "password"
    )

    @dewback = Dewback.create!(
      title: "Sample Dewback", color: "Green", size: "Medium", max_speed: "Fast",
      max_load: "Moderate", food_requirements: "Low", price: 1500, quantity: 1,
      description: "A nice test dewback"
    )

    @ownership = Owner.create!(
      user: @user,
      dewback: @dewback,
      available_for_trade: false
    )

    sign_in @user
  end

  test "should get index" do
    get my_dewbacks_url
    assert_response :success
    assert_select "h1", /My Purchased Dewbacks/i
  end

  test "should mark dewback for trade" do
    patch mark_for_trade_my_dewback_url(@dewback.id)
    assert_redirected_to my_dewbacks_path
    follow_redirect!
    assert_match "Dewback marked as available for trade.", response.body
    assert @ownership.reload.available_for_trade
  end

  test "should remove dewback from trade" do
    @ownership.update!(available_for_trade: true)
    patch remove_from_trade_my_dewback_url(@dewback.id)
    assert_redirected_to my_dewbacks_path
    follow_redirect!
    assert_match "Dewback removed from trade.", response.body
    refute @ownership.reload.available_for_trade
  end

  test "should not mark non-owned dewback for trade" do
    patch mark_for_trade_my_dewback_url(99999)
    assert_redirected_to my_dewbacks_path
    follow_redirect!
    assert_match "Could not mark dewback for trade", response.body
  end

  test "should not remove non-owned dewback from trade" do
    patch remove_from_trade_my_dewback_url(99999)
    assert_redirected_to my_dewbacks_path
    follow_redirect!
    assert_match "Could not remove dewback from trade", response.body
  end
end
