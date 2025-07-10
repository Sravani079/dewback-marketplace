require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "cartuser_#{SecureRandom.hex(4)}@example.com",
      name: "Cart User",
      password: "password"
    )
    sign_in @user

    @dewback = Dewback.create!(
      title: "Fastback",
      color: "Green",
      size: "Large",
      max_speed: "Fast",
      max_load: "Heavy",
      food_requirements: "Low",
      price: 1000,
      quantity: 5
    )

    @cart = Cart.create!(user: @user)
  end

  test "should show cart" do
    get cart_url
    assert_response :success
    assert_match "Cart", response.body
  end

  test "should add dewback to cart" do
    assert_difference("CartItem.count", 1) do
      post add_to_cart_url(dewback_id: @dewback.id)
    end
    assert_redirected_to dewback_path(@dewback)
  end

  test "should update cart item quantity" do
    item = @cart.cart_items.create!(dewback: @dewback, quantity: 1)

    patch cart_url, params: {
      items: {
        "#{item.id}": { quantity: 3 }
      }
    }

    assert_redirected_to cart_url
    item.reload
    assert_equal 3, item.quantity
  end

  test "should destroy cart items" do
    @cart.cart_items.create!(dewback: @dewback, quantity: 2)
    delete cart_url
    assert_redirected_to cart_url
    assert_equal 0, @user.cart.cart_items.count
  end

  test "should reorder cart from order" do
    order = Order.create!(
      user: @user,
      name: "Past Order",
      address: "Old Street",
      delivery_method: "shipping",
      dewback_name: @dewback.title,
      payment_method: PaymentMethod.create!(
        user: @user,
        provider: "visa",
        method_type: "card",
        token: "tok123",
        last4: "4242",
        exp_month: 12,
        exp_year: 2029
      )
    )

    post reorder_cart_url(order_id: order.id)
    assert_redirected_to cart_url
    assert_equal 1, @user.cart.cart_items.count
  end
end
