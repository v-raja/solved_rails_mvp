require "application_system_test_case"

class NichesTest < ApplicationSystemTestCase
  setup do
    @nich = niches(:one)
  end

  test "visiting the index" do
    visit niches_url
    assert_selector "h1", text: "Niches"
  end

  test "creating a Niche" do
    visit niches_url
    click_on "New Niche"

    fill_in "Code", with: @nich.code
    fill_in "Description", with: @nich.description
    fill_in "Slug", with: @nich.slug
    fill_in "Title", with: @nich.title
    click_on "Create Niche"

    assert_text "Niche was successfully created"
    click_on "Back"
  end

  test "updating a Niche" do
    visit niches_url
    click_on "Edit", match: :first

    fill_in "Code", with: @nich.code
    fill_in "Description", with: @nich.description
    fill_in "Slug", with: @nich.slug
    fill_in "Title", with: @nich.title
    click_on "Update Niche"

    assert_text "Niche was successfully updated"
    click_on "Back"
  end

  test "destroying a Niche" do
    visit niches_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Niche was successfully destroyed"
  end
end
