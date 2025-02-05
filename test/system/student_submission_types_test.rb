require "application_system_test_case"

class StudentSubmissionTypesTest < ApplicationSystemTestCase
  setup do
    @student_submission_type = student_submission_types(:one)
  end

  test "visiting the index" do
    visit student_submission_types_url
    assert_selector "h1", text: "Student submission types"
  end

  test "should create student submission type" do
    visit student_submission_types_url
    click_on "New student submission type"

    fill_in "Accepted filetype", with: @student_submission_type.accepted_filetype
    fill_in "Description", with: @student_submission_type.description
    fill_in "Max submissions", with: @student_submission_type.max_submissions
    fill_in "Name", with: @student_submission_type.name
    check "Optional" if @student_submission_type.optional
    click_on "Create Student submission type"

    assert_text "Student submission type was successfully created"
    click_on "Back"
  end

  test "should update Student submission type" do
    visit student_submission_type_url(@student_submission_type)
    click_on "Edit this student submission type", match: :first

    fill_in "Accepted filetype", with: @student_submission_type.accepted_filetype
    fill_in "Description", with: @student_submission_type.description
    fill_in "Max submissions", with: @student_submission_type.max_submissions
    fill_in "Name", with: @student_submission_type.name
    check "Optional" if @student_submission_type.optional
    click_on "Update Student submission type"

    assert_text "Student submission type was successfully updated"
    click_on "Back"
  end

  test "should destroy Student submission type" do
    visit student_submission_type_url(@student_submission_type)
    click_on "Destroy this student submission type", match: :first

    assert_text "Student submission type was successfully destroyed"
  end
end
