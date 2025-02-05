require "application_system_test_case"

class InvitedSubmissionsTest < ApplicationSystemTestCase
  setup do
    @invited_submission = invited_submissions(:one)
  end

  test "visiting the index" do
    visit invited_submissions_url
    assert_selector "h1", text: "Invited submissions"
  end

  test "should create invited submission" do
    visit invited_submissions_url
    click_on "New invited submission"

    fill_in "Invitation", with: @invited_submission.invitation_id
    fill_in "Submission", with: @invited_submission.submission_id
    click_on "Create Invited submission"

    assert_text "Invited submission was successfully created"
    click_on "Back"
  end

  test "should update Invited submission" do
    visit invited_submission_url(@invited_submission)
    click_on "Edit this invited submission", match: :first

    fill_in "Invitation", with: @invited_submission.invitation_id
    fill_in "Submission", with: @invited_submission.submission_id
    click_on "Update Invited submission"

    assert_text "Invited submission was successfully updated"
    click_on "Back"
  end

  test "should destroy Invited submission" do
    visit invited_submission_url(@invited_submission)
    click_on "Destroy this invited submission", match: :first

    assert_text "Invited submission was successfully destroyed"
  end
end
