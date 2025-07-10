require "test_helper"

class AdminDewbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
      @admin = User.create!(
    email: "admin#{SecureRandom.hex(4)}@example.com",
    name: "test1",
    password: "password",
    admin: true
  )
    @dewback = Dewback.create!(
      title: "Test Dewback", color: "Green", size: "Large", max_speed: "Fast",
      max_load: "Heavy", food_requirements: "High", price: 3000, quantity: 1,
      description: "A test dewback"
    )
  end

  test "should get new if admin" do
    sign_in_as(@admin)
    get new_admin_dewback_url
    assert_response :success
  end

  test "should create dewback" do
    sign_in_as(@admin)
    assert_difference("Dewback.count") do
      post admin_dewbacks_url, params: {
        dewback: {
          title: "New", color: "Blue", size: "Medium", max_speed: "Moderate",
          max_load: "Light", food_requirements: "Moderate", price: 1000, quantity: 2,
          description: "Brand new Dewback"
        }
      }
    end
    assert_redirected_to catalog_index_url
  end

  test "should get edit" do
    sign_in_as(@admin)
    get edit_admin_dewback_url(@dewback)
    assert_response :success
  end

  test "should update dewback" do
    sign_in_as(@admin)
    patch admin_dewback_url(@dewback), params: {
      dewback: { title: "Updated Title" }
    }
    assert_redirected_to catalog_index_url
    @dewback.reload
    assert_equal "Updated Title", @dewback.title
  end

  private

  def sign_in_as(user)
    post user_session_url, params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }
  end
end
