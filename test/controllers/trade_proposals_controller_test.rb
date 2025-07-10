require "test_helper"

class TradeProposalsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @sender = User.create!(
      email: "sender_#{SecureRandom.hex(4)}@example.com",
      name: "Sender",
      password: "password"
    )

    @recipient = User.create!(
      email: "recipient_#{SecureRandom.hex(4)}@example.com",
      name: "Recipient",
      password: "password"
    )

    @dewback = Dewback.create!(
      title: "Tradable One",
      color: "Gray",
      size: "Large",
      max_speed: "Fast",
      max_load: "Medium",
      food_requirements: "Low",
      price: 1200,
      quantity: 1
    )

    @recipient_owner = Owner.create!(user: @recipient, dewback: @dewback, available_for_trade: true)

    @owned_dewback = Dewback.create!(
      title: "Sender's Dewback",
      color: "Blue",
      size: "Small",
      max_speed: "Fast",
      max_load: "Light",
      food_requirements: "Low",
      price: 1000,
      quantity: 1
    )

    Owner.create!(user: @sender, dewback: @owned_dewback, available_for_trade: true)

    sign_in @sender
  end

  test "should get new trade proposal form" do
    get new_trade_proposal_url(dewback_id: @dewback.id)
    assert_response :success
    assert_select "form"
  end

  test "should redirect if dewback not found" do
    get new_trade_proposal_url(dewback_id: -1)
    assert_redirected_to trade_market_path
    follow_redirect!
    assert_match /not found/i, response.body
  end

  test "should redirect if dewback has no owner" do
    @recipient_owner.destroy
    get new_trade_proposal_url(dewback_id: @dewback.id)
    assert_redirected_to trade_market_path
    follow_redirect!
    assert_match /has no owner/i, response.body
  end

  test "should create trade proposal with offered dewbacks" do
    assert_difference("TradeProposal.count", 1) do
      post trade_proposals_url, params: {
        recipient_id: @recipient.id,
        recipient_dewback_id: @dewback.id,
        offered_dewback_ids: [@owned_dewback.id]
      }
    end
    assert_redirected_to trade_market_path
    follow_redirect!
    assert_match /success/i, response.body
  end

  test "should handle failed save gracefully" do
    TradeProposal.any_instance.stubs(:save).returns(false)

    assert_no_difference("TradeProposal.count") do
      post trade_proposals_url, params: {
        recipient_id: @recipient.id,
        recipient_dewback_id: @dewback.id,
        offered_dewback_ids: [@owned_dewback.id]
      }
    end

    assert_redirected_to trade_market_path
    follow_redirect!
    assert_match /could not be saved/i, response.body
  end

  test "should redirect to login if not authenticated" do
    sign_out @sender
    get new_trade_proposal_url(dewback_id: @dewback.id)
    assert_redirected_to new_user_session_path
  end
end
