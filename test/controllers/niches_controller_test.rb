require 'test_helper'

class NichesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nich = niches(:one)
  end

  test "should get index" do
    get niches_url
    assert_response :success
  end

  test "should get new" do
    get new_nich_url
    assert_response :success
  end

  test "should create nich" do
    assert_difference('Niche.count') do
      post niches_url, params: { nich: { code: @nich.code, description: @nich.description, slug: @nich.slug, title: @nich.title } }
    end

    assert_redirected_to nich_url(Niche.last)
  end

  test "should show nich" do
    get nich_url(@nich)
    assert_response :success
  end

  test "should get edit" do
    get edit_nich_url(@nich)
    assert_response :success
  end

  test "should update nich" do
    patch nich_url(@nich), params: { nich: { code: @nich.code, description: @nich.description, slug: @nich.slug, title: @nich.title } }
    assert_redirected_to nich_url(@nich)
  end

  test "should destroy nich" do
    assert_difference('Niche.count', -1) do
      delete nich_url(@nich)
    end

    assert_redirected_to niches_url
  end
end
