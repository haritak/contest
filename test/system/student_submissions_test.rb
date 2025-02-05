require "application_system_test_case"

class StudentSubmissionsTest < ApplicationSystemTestCase
  setup do
    @student_submission = student_submissions(:one)
  end

  test "visiting the index" do
    visit student_submissions_url
    assert_selector "h1", text: "Student submissions"
  end

  test "should create student submission" do
    visit student_submissions_url
    click_on "New student submission"

    check "Finalized" if @student_submission.finalized
    fill_in "Finalized date", with: @student_submission.finalized_date
    fill_in "Notes", with: @student_submission.notes
    fill_in "Student", with: @student_submission.student_id
    fill_in "Student submission type", with: @student_submission.student_submission_type_id
    fill_in "Title", with: @student_submission.title
    fill_in "User", with: @student_submission.user_id
    click_on "Create Student submission"

    assert_text "Student submission was successfully created"
    click_on "Back"
  end

  test "should update Student submission" do
    visit student_submission_url(@student_submission)
    click_on "Edit this student submission", match: :first

    check "Finalized" if @student_submission.finalized
    fill_in "Finalized date", with: @student_submission.finalized_date
    fill_in "Notes", with: @student_submission.notes
    fill_in "Student", with: @student_submission.student_id
    fill_in "Student submission type", with: @student_submission.student_submission_type_id
    fill_in "Title", with: @student_submission.title
    fill_in "User", with: @student_submission.user_id
    click_on "Update Student submission"

    assert_text "Student submission was successfully updated"
    click_on "Back"
  end

  test "should destroy Student submission" do
    visit student_submission_url(@student_submission)
    click_on "Destroy this student submission", match: :first

    assert_text "Student submission was successfully destroyed"
  end
end
