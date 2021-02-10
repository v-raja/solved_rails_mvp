require 'test_helper'

class MiniRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mini_request = mini_requests(:one)
  end

  test "should get index" do
    get mini_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_mini_request_url
    assert_response :success
  end

  test "should create mini_request" do
    assert_difference('MiniRequest.count') do
      post mini_requests_url, params: { mini_request: { description: @mini_request.description, email: @mini_request.email, user_id: @mini_request.user_id } }
    end

    assert_redirected_to mini_request_url(MiniRequest.last)
  end

  test "should show mini_request" do
    get mini_request_url(@mini_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_mini_request_url(@mini_request)
    assert_response :success
  end

  test "should update mini_request" do
    patch mini_request_url(@mini_request), params: { mini_request: { description: @mini_request.description, email: @mini_request.email, user_id: @mini_request.user_id } }
    assert_redirected_to mini_request_url(@mini_request)
  end

  test "should destroy mini_request" do
    assert_difference('MiniRequest.count', -1) do
      delete mini_request_url(@mini_request)
    end

    assert_redirected_to mini_requests_url
  end
end
