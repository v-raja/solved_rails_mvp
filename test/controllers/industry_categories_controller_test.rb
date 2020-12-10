require 'test_helper'

class IndustryCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @industry_category = industry_categories(:one)
  end

  test "should get index" do
    get industry_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_industry_category_url
    assert_response :success
  end

  test "should create industry_category" do
    assert_difference('IndustryCategory.count') do
      post industry_categories_url, params: { industry_category: { code: @industry_category.code, description: @industry_category.description, title: @industry_category.title } }
    end

    assert_redirected_to industry_category_url(IndustryCategory.last)
  end

  test "should show industry_category" do
    get industry_category_url(@industry_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_industry_category_url(@industry_category)
    assert_response :success
  end

  test "should update industry_category" do
    patch industry_category_url(@industry_category), params: { industry_category: { code: @industry_category.code, description: @industry_category.description, title: @industry_category.title } }
    assert_redirected_to industry_category_url(@industry_category)
  end

  test "should destroy industry_category" do
    assert_difference('IndustryCategory.count', -1) do
      delete industry_category_url(@industry_category)
    end

    assert_redirected_to industry_categories_url
  end
end
