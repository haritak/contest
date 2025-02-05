require "application_system_test_case"

class SpecialitiesTest < ApplicationSystemTestCase
  setup do
    @speciality = specialities(:one)
  end

  test "visiting the index" do
    visit specialities_url
    assert_selector "h1", text: "Specialities"
  end

  test "should create speciality" do
    visit specialities_url
    click_on "New speciality"

    fill_in "Code", with: @speciality.code
    fill_in "Description", with: @speciality.description
    click_on "Create Speciality"

    assert_text "Speciality was successfully created"
    click_on "Back"
  end

  test "should update Speciality" do
    visit speciality_url(@speciality)
    click_on "Edit this speciality", match: :first

    fill_in "Code", with: @speciality.code
    fill_in "Description", with: @speciality.description
    click_on "Update Speciality"

    assert_text "Speciality was successfully updated"
    click_on "Back"
  end

  test "should destroy Speciality" do
    visit speciality_url(@speciality)
    click_on "Destroy this speciality", match: :first

    assert_text "Speciality was successfully destroyed"
  end
end
