require "application_system_test_case"

class EducationDirectoratesTest < ApplicationSystemTestCase
  setup do
    @education_directorate = education_directorates(:one)
  end

  test "visiting the index" do
    visit education_directorates_url
    assert_selector "h1", text: "Education directorates"
  end

  test "should create education directorate" do
    visit education_directorates_url
    click_on "New education directorate"

    fill_in "Name", with: @education_directorate.name
    click_on "Create Education directorate"

    assert_text "Education directorate was successfully created"
    click_on "Back"
  end

  test "should update Education directorate" do
    visit education_directorate_url(@education_directorate)
    click_on "Edit this education directorate", match: :first

    fill_in "Name", with: @education_directorate.name
    click_on "Update Education directorate"

    assert_text "Education directorate was successfully updated"
    click_on "Back"
  end

  test "should destroy Education directorate" do
    visit education_directorate_url(@education_directorate)
    click_on "Destroy this education directorate", match: :first

    assert_text "Education directorate was successfully destroyed"
  end
end
