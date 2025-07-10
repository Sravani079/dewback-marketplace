require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "reviewer#{SecureRandom.hex(4)}@example.com",
      name: "test1",
      password: "password"
    )
    @dewback = Dewback.create!(
      title: "Reviewable Dewback", color: "Red", size: "Medium",
      max_speed: "Fast", max_load: "Moderate", food_requirements: "Low",
      price: 1000, quantity: 2, description: "Dewback for testing reviews"
    )
    sign_in @user
  end

  test "should create review with valid data" do
    assert_difference("Review.count", 1) do
      post dewback_reviews_url(@dewback), params: {
        review: {
          rating: 5,
          comment: "Excellent dewback!",
          image: nil
        }
      }
    end
    assert_redirected_to dewback_url(@dewback)
    follow_redirect!
    assert_match "Review submitted successfully", response.body
  end

  test "should not create review with missing rating" do
    assert_no_difference("Review.count") do
      post dewback_reviews_url(@dewback), params: {
        review: {
          rating: nil,
          comment: "Missing rating"
        }
      }
    end
    assert_redirected_to dewback_url(@dewback)
    follow_redirect!
    assert_match "Unable to submit review", response.body
  end

  test "should not create review with invalid rating" do
    assert_no_difference("Review.count") do
      post dewback_reviews_url(@dewback), params: {
        review: {
          rating: 10, # Invalid
          comment: "Out of range"
        }
      }
    end
    assert_redirected_to dewback_url(@dewback)
    follow_redirect!
    assert_match "Unable to submit review", response.body
  end

  test "should not create review with missing comment" do
    assert_no_difference("Review.count") do
      post dewback_reviews_url(@dewback), params: {
        review: {
          rating: 3,
          comment: "" # Invalid
        }
      }
    end
    assert_redirected_to dewback_url(@dewback)
    follow_redirect!
    assert_match "Unable to submit review", response.body
  end

  test "should require user to be signed in" do
    sign_out @user
    post dewback_reviews_url(@dewback), params: {
      review: {
        rating: 4,
        comment: "Signed out user"
      }
    }
    assert_redirected_to new_user_session_path
  end
end
