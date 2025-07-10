require "test_helper"

class CatalogControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dewback1 = Dewback.create!(
      title: "Fast Green Dewback", color: "Green", size: "Small",
      max_speed: "Fast", max_load: "Light", food_requirements: "Low",
      price: 100, quantity: 1, description: "Zooms fast"
    )

    @dewback2 = Dewback.create!(
      title: "Heavy Blue Dewback", color: "Blue", size: "Large",
      max_speed: "Slow", max_load: "Heavy", food_requirements: "High",
      price: 300, quantity: 2, description: "Carries more"
    )
  end

  test "should get index" do
    get catalog_index_url
    assert_response :success
    assert_select "h1", text: "Dewback Catalog"
  end

  test "should filter by color" do
    get catalog_index_url, params: { color: "Green" }
    assert_response :success
    assert_includes assigns(:dewbacks), @dewback1
    assert_not_includes assigns(:dewbacks), @dewback2
  end

  test "should filter by size" do
    get catalog_index_url, params: { size: "Large" }
    assert_response :success
    assert_includes assigns(:dewbacks), @dewback2
    assert_not_includes assigns(:dewbacks), @dewback1
  end

  test "should sort by price ascending" do
    get catalog_index_url, params: { sort_by: "price_asc" }
    assert_response :success
    dewbacks = assigns(:dewbacks).to_a
  
    assert_operator dewbacks[0].price, :<=, dewbacks[1].price
  end
  

  test "should sort by price descending" do
    get catalog_index_url, params: { sort_by: "price_desc" }
    assert_response :success
    dewbacks = assigns(:dewbacks).to_a
  
    assert_operator dewbacks[0].price, :>=, dewbacks[1].price
  end
  

  test "should search by title" do
    get catalog_index_url, params: { query: "Fast" }
    assert_response :success
    assert_includes assigns(:dewbacks), @dewback1
    assert_not_includes assigns(:dewbacks), @dewback2
  end
end
