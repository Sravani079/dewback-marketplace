require "test_helper"

class WishlistsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "wishlist_#{SecureRandom.hex(4)}@example.com",
      name: "Test User",
      password: "password"
    )

    @dewback = Dewback.create!(
      title: "Desert Runner",
      color: "Tan",
      size: "Large",
      max_speed: "Moderate",
      max_load: "Heavy",
      food_requirements: "Low",
      price: 1000,
      quantity: 5
    )

    sign_in @user
  end

  test "should get index" do
    get wishlists_url
    assert_response :success
  end

  test "should add dewback to wishlist" do
    assert_difference('Wishlist.count', 1) do
      post wishlists_url, params: { dewback_id: @dewback.id }
    end
    assert_redirected_to dewback_path(@dewback)
    follow_redirect!
    assert_match /added to your wishlist/i, response.body
  end

  test "should not add duplicate dewback" do
    Wishlist.create!(user: @user, dewback: @dewback)
    assert_no_difference('Wishlist.count') do
      post wishlists_url, params: { dewback_id: @dewback.id }
    end
    assert_redirected_to dewback_path(@dewback)
    follow_redirect!
    assert_match /already in your wishlist/i, response.body
  end

  test "should handle invalid dewback" do
    assert_no_difference('Wishlist.count') do
      post wishlists_url, params: { dewback_id: -1 }
    end
    assert_redirected_to dewback_catalog_path
    follow_redirect!
    assert_match /not found/i, response.body
  end

  test "should handle failed wishlist save" do
    Wishlist.any_instance.stubs(:save).returns(false)
    assert_no_difference('Wishlist.count') do
      post wishlists_url, params: { dewback_id: @dewback.id }
    end
    assert_redirected_to dewback_path(@dewback)
    follow_redirect!
    assert_match /could not add/i, response.body
  end

  test "should delete wishlist item" do
    wishlist = Wishlist.create!(user: @user, dewback: @dewback)
    assert_difference('Wishlist.count', -1) do
      delete wishlist_url(wishlist)
    end
    assert_redirected_to wishlists_url
    follow_redirect!
    assert_match /removed from your wishlist/i, response.body
  end

  test "should handle missing wishlist item on delete" do
    assert_no_difference('Wishlist.count') do
      delete wishlist_url(id: -1)
    end
    assert_redirected_to wishlists_url
    follow_redirect!
    assert_match /not found/i, response.body
  end
end
