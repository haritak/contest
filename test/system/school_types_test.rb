require "application_system_test_case"

class SchoolTypesTest < ApplicationSystemTestCase
  setup do
    @school_type = school_types(:one)
  end

  test "visiting the index" do
    visit school_types_url
    assert_selector "h1", text: "School types"
  end

  test "should create school type" do
    visit school_types_url
    click_on "New school type"

    fill_in "School type", with: @school_type.school_type
    click_on "Create School type"

    assert_text "School type was successfully created"
    click_on "Back"
  end

  test "should update School type" do
    visit school_type_url(@school_type)
    click_on "Edit this school type", match: :first

    fill_in "School type", with: @school_type.school_type
    click_on "Update School type"

    assert_text "School type was successfully updated"
    click_on "Back"
  end

  test "should destroy School type" do
    visit school_type_url(@school_type)
    click_on "Destroy this school type", match: :first

    assert_text "School type was successfully destroyed"
  end
end
