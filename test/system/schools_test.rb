require "application_system_test_case"

class SchoolsTest < ApplicationSystemTestCase
  setup do
    @school = schools(:one)
  end

  test "visiting the index" do
    visit schools_url
    assert_selector "h1", text: "Schools"
  end

  test "should create school" do
    visit schools_url
    click_on "New school"

    fill_in "Contact email", with: @school.contact_email
    fill_in "Contact phone", with: @school.contact_phone
    fill_in "Name", with: @school.name
    fill_in "School type", with: @school.school_type
    fill_in "User", with: @school.user_id
    click_on "Create School"

    assert_text "School was successfully created"
    click_on "Back"
  end

  test "should update School" do
    visit school_url(@school)
    click_on "Edit this school", match: :first

    fill_in "Contact email", with: @school.contact_email
    fill_in "Contact phone", with: @school.contact_phone
    fill_in "Name", with: @school.name
    fill_in "School type", with: @school.school_type
    fill_in "User", with: @school.user_id
    click_on "Update School"

    assert_text "School was successfully updated"
    click_on "Back"
  end

  test "should destroy School" do
    visit school_url(@school)
    click_on "Destroy this school", match: :first

    assert_text "School was successfully destroyed"
  end
end
