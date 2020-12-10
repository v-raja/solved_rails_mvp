require "application_system_test_case"

class OccupationCategoriesTest < ApplicationSystemTestCase
  setup do
    @occupation_category = occupation_categories(:one)
  end

  test "visiting the index" do
    visit occupation_categories_url
    assert_selector "h1", text: "Occupation Categories"
  end

  test "creating a Occupation category" do
    visit occupation_categories_url
    click_on "New Occupation Category"

    fill_in "Code", with: @occupation_category.code
    fill_in "Slug", with: @occupation_category.slug
    fill_in "Title", with: @occupation_category.title
    click_on "Create Occupation category"

    assert_text "Occupation category was successfully created"
    click_on "Back"
  end

  test "updating a Occupation category" do
    visit occupation_categories_url
    click_on "Edit", match: :first

    fill_in "Code", with: @occupation_category.code
    fill_in "Slug", with: @occupation_category.slug
    fill_in "Title", with: @occupation_category.title
    click_on "Update Occupation category"

    assert_text "Occupation category was successfully updated"
    click_on "Back"
  end

  test "destroying a Occupation category" do
    visit occupation_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Occupation category was successfully destroyed"
  end
end
