require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_get_it_url
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: { image_url: @product.image_url, name: @product.name } }
    end

    assert_redirected_to get_it_url(Product.last)
  end

  test "should show product" do
    get get_it_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_get_it_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch get_it_url(@product), params: { product: { image_url: @product.image_url, name: @product.name } }
    assert_redirected_to get_it_url(@product)
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete get_it_url(@product)
    end

    assert_redirected_to products_url
  end
end
