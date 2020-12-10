require 'test_helper'

class OccupationCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @occupation_category = occupation_categories(:one)
  end

  test "should get index" do
    get occupation_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_occupation_category_url
    assert_response :success
  end

  test "should create occupation_category" do
    assert_difference('OccupationCategory.count') do
      post occupation_categories_url, params: { occupation_category: { code: @occupation_category.code, slug: @occupation_category.slug, title: @occupation_category.title } }
    end

    assert_redirected_to occupation_category_url(OccupationCategory.last)
  end

  test "should show occupation_category" do
    get occupation_category_url(@occupation_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_occupation_category_url(@occupation_category)
    assert_response :success
  end

  test "should update occupation_category" do
    patch occupation_category_url(@occupation_category), params: { occupation_category: { code: @occupation_category.code, slug: @occupation_category.slug, title: @occupation_category.title } }
    assert_redirected_to occupation_category_url(@occupation_category)
  end

  test "should destroy occupation_category" do
    assert_difference('OccupationCategory.count', -1) do
      delete occupation_category_url(@occupation_category)
    end

    assert_redirected_to occupation_categories_url
  end
end
