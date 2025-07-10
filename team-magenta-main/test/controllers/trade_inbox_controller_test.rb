require "test_helper"

class TradeInboxControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @recipient = User.create!(
      email: "recipient#{SecureRandom.hex(4)}@example.com",
      name: "test1",
      password: "password"
    )
    @proposer = User.create!(
      email: "proposer#{SecureRandom.hex(4)}@example.com",
      name: "test2",
      password: "password"
    )
    @dewback1 = Dewback.create!(
      title: "Proposer's Dewback", color: "Blue", size: "Large",
      max_speed: "Slow", max_load: "Heavy", food_requirements: "High",
      price: 1000, quantity: 1, description: "A test dewback"
    )
    @dewback2 = Dewback.create!(
      title: "Recipient's Dewback", color: "Green", size: "Small",
      max_speed: "Fast", max_load: "Light", food_requirements: "Low",
      price: 800, quantity: 1, description: "Another test dewback"
    )
    @proposal = TradeProposal.create!(
      proposer: @proposer,
      recipient: @recipient,
      status: "pending"
    )
    @proposal.offered_dewbacks.create!(dewback: @dewback1)
    @proposal.requested_dewbacks.create!(dewback: @dewback2)
  end

  test "renders index when user is signed in" do
    sign_in @recipient
    get trade_inbox_index_url
    assert_response :success
    assert_select "h2", text: /Your Trade Inbox/i
  end

  test "redirects show if recipient is incorrect" do
    sign_in @proposer
    get trade_proposal_details_url(@proposal)
    assert_redirected_to trade_inbox_path
    follow_redirect!
    assert_match "Access denied", response.body
  end

  test "shows alert if proposal not found" do
    sign_in @recipient
    get trade_proposal_details_url(id: "non-existent-id")
    assert_redirected_to trade_inbox_path
    follow_redirect!
    assert_match "Trade proposal not found", response.body
  end

  test "rejects trade proposal" do
    sign_in @recipient
    post reject_trade_inbox_url(@proposal)
    assert_redirected_to trade_inbox_path
    follow_redirect!
    assert_match "Trade rejected successfully", response.body
    assert_equal "rejected", @proposal.reload.status
  end
end
