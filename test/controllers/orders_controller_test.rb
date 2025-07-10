require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "user_#{SecureRandom.hex(4)}@example.com",
      name: "Test User",
      password: "password"
    )
    sign_in @user

    @dewback = Dewback.create!(
      title: "Speedster",
      color: "Green",
      size: "Large",
      max_speed: "Fast",
      max_load: "Heavy",
      food_requirements: "Low",
      price: 1200,
      quantity: 5
    )

    @cart = Cart.create!(user: @user)
    @cart.cart_items.create!(dewback: @dewback, quantity: 2)

    @saved_card = PaymentMethod.create!(
      user: @user,
      provider: "Visa",
      method_type: "card",
      token: "tok_card",
      last4: "1234",
      exp_month: 12,
      exp_year: 2029
    )

    @paypal = PaymentMethod.create!(
      user: @user,
      provider: "paypal",
      method_type: "paypal",
      token: "tok_paypal",
      last4: "N/A"
    )
  end

  test "should get new order page" do
    get new_order_url
    assert_response :success
    assert_match "Cart", response.body
  end

  test "should create order using saved payment method" do
    assert_difference("Order.count", 1) do
      post orders_url, params: {
        order: {
          name: "Saved Card Order",
          address: "123 Space Way",
          delivery_method: "shipping"
        },
        saved_payment_method_id: @saved_card.id
      }
    end
    assert_redirected_to confirmation_order_path(Order.last)
  end

  test "should create order using paypal" do
    assert_difference("Order.count", 1) do
      post orders_url, params: {
        order: {
          name: "PayPal Order",
          address: "456 Sand Dune",
          delivery_method: "shipping"
        },
        payment_method_type: "paypal"
      }
    end
    assert_redirected_to confirmation_order_path(Order.last)
  end

  test "should create order using new card without saving" do
    assert_difference("Order.count", 1) do
      post orders_url, params: {
        order: {
          name: "New Card Temp",
          address: "789 Vapor St",
          delivery_method: "shipping"
        },
        payment_method_type: "credit_card",
        card_number: "4111111111111111",
        expiry_date: "12/30",
        save_payment_method: "0"
      }
    end
    assert_redirected_to confirmation_order_path(Order.last)
  end

  test "should create order using new card and save it" do
    assert_difference("Order.count", 1) do
      post orders_url, params: {
        order: {
          name: "Saved New Card",
          address: "Sky Tower",
          delivery_method: "shipping"
        },
        payment_method_type: "debit_card",
        card_number: "4000000000000002",
        expiry_date: "11/31",
        save_payment_method: "1"
      }
    end
    assert_redirected_to confirmation_order_path(Order.last)
  end

  test "should not create order without payment method" do
    assert_no_difference("Order.count") do
      post orders_url, params: {
        order: {
          name: "Invalid Order",
          address: "No Pay",
          delivery_method: "shipping"
        }
      }
    end
    assert_response :unprocessable_entity
    assert_match "Please provide a valid payment method", response.body
  end

  test "should not parse invalid expiry date" do
    controller = OrdersController.new
    month, year = controller.send(:parse_expiry, "invalid")
    assert_nil month
    assert_nil year
  end

  test "should show order confirmation page" do
    order = create_order_with(@user, @saved_card)
    get confirmation_order_url(order)
    assert_response :success
  end

  test "should show order page" do
    order = create_order_with(@user, @saved_card)
    get order_url(order)
    assert_response :success
  end

  test "should redirect new if not logged in" do
    sign_out @user
    get new_order_url
    assert_redirected_to new_user_session_path
  end

  private

  def create_order_with(user, method)
    Order.create!(
      user: user,
      name: "Test Show",
      address: "Show Lane",
      delivery_method: "shipping",
      dewback_name: "Speedster",
      number_of_items: 2,
      payment_method: method
    )
  end
end
