require "application_system_test_case"

class MiniRequestsTest < ApplicationSystemTestCase
  setup do
    @mini_request = mini_requests(:one)
  end

  test "visiting the index" do
    visit mini_requests_url
    assert_selector "h1", text: "Mini Requests"
  end

  test "creating a Mini request" do
    visit mini_requests_url
    click_on "New Mini Request"

    fill_in "Description", with: @mini_request.description
    fill_in "Email", with: @mini_request.email
    fill_in "User", with: @mini_request.user_id
    click_on "Create Mini request"

    assert_text "Mini request was successfully created"
    click_on "Back"
  end

  test "updating a Mini request" do
    visit mini_requests_url
    click_on "Edit", match: :first

    fill_in "Description", with: @mini_request.description
    fill_in "Email", with: @mini_request.email
    fill_in "User", with: @mini_request.user_id
    click_on "Update Mini request"

    assert_text "Mini request was successfully updated"
    click_on "Back"
  end

  test "destroying a Mini request" do
    visit mini_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mini request was successfully destroyed"
  end
end
