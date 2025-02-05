require "test_helper"

class StudentSubmissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_submission = student_submissions(:one)
  end

  test "should get index" do
    get student_submissions_url
    assert_response :success
  end

  test "should get new" do
    get new_student_submission_url
    assert_response :success
  end

  test "should create student_submission" do
    assert_difference("StudentSubmission.count") do
      post student_submissions_url, params: { student_submission: { finalized: @student_submission.finalized, finalized_date: @student_submission.finalized_date, notes: @student_submission.notes, student_id: @student_submission.student_id, student_submission_type_id: @student_submission.student_submission_type_id, title: @student_submission.title, user_id: @student_submission.user_id } }
    end

    assert_redirected_to student_submission_url(StudentSubmission.last)
  end

  test "should show student_submission" do
    get student_submission_url(@student_submission)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_submission_url(@student_submission)
    assert_response :success
  end

  test "should update student_submission" do
    patch student_submission_url(@student_submission), params: { student_submission: { finalized: @student_submission.finalized, finalized_date: @student_submission.finalized_date, notes: @student_submission.notes, student_id: @student_submission.student_id, student_submission_type_id: @student_submission.student_submission_type_id, title: @student_submission.title, user_id: @student_submission.user_id } }
    assert_redirected_to student_submission_url(@student_submission)
  end

  test "should destroy student_submission" do
    assert_difference("StudentSubmission.count", -1) do
      delete student_submission_url(@student_submission)
    end

    assert_redirected_to student_submissions_url
  end
end
