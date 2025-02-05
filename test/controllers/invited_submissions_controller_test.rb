require "test_helper"

class InvitedSubmissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invited_submission = invited_submissions(:one)
  end

  test "should get index" do
    get invited_submissions_url
    assert_response :success
  end

  test "should get new" do
    get new_invited_submission_url
    assert_response :success
  end

  test "should create invited_submission" do
    assert_difference("InvitedSubmission.count") do
      post invited_submissions_url, params: { invited_submission: { invitation_id: @invited_submission.invitation_id, submission_id: @invited_submission.submission_id } }
    end

    assert_redirected_to invited_submission_url(InvitedSubmission.last)
  end

  test "should show invited_submission" do
    get invited_submission_url(@invited_submission)
    assert_response :success
  end

  test "should get edit" do
    get edit_invited_submission_url(@invited_submission)
    assert_response :success
  end

  test "should update invited_submission" do
    patch invited_submission_url(@invited_submission), params: { invited_submission: { invitation_id: @invited_submission.invitation_id, submission_id: @invited_submission.submission_id } }
    assert_redirected_to invited_submission_url(@invited_submission)
  end

  test "should destroy invited_submission" do
    assert_difference("InvitedSubmission.count", -1) do
      delete invited_submission_url(@invited_submission)
    end

    assert_redirected_to invited_submissions_url
  end
end
