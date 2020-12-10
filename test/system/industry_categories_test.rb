require "application_system_test_case"

class IndustryCategoriesTest < ApplicationSystemTestCase
  setup do
    @industry_category = industry_categories(:one)
  end

  test "visiting the index" do
    visit industry_categories_url
    assert_selector "h1", text: "Industry Categories"
  end

  test "creating a Industry category" do
    visit industry_categories_url
    click_on "New Industry Category"

    fill_in "Code", with: @industry_category.code
    fill_in "Description", with: @industry_category.description
    fill_in "Title", with: @industry_category.title
    click_on "Create Industry category"

    assert_text "Industry category was successfully created"
    click_on "Back"
  end

  test "updating a Industry category" do
    visit industry_categories_url
    click_on "Edit", match: :first

    fill_in "Code", with: @industry_category.code
    fill_in "Description", with: @industry_category.description
    fill_in "Title", with: @industry_category.title
    click_on "Update Industry category"

    assert_text "Industry category was successfully updated"
    click_on "Back"
  end

  test "destroying a Industry category" do
    visit industry_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Industry category was successfully destroyed"
  end
end
