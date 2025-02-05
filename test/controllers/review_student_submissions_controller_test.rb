require "test_helper"

class ReviewStudentSubmissionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get review_student_submissions_index_url
    assert_response :success
  end

  test "should get show" do
    get review_student_submissions_show_url
    assert_response :success
  end

  test "should get next" do
    get review_student_submissions_next_url
    assert_response :success
  end

  test "should get previous" do
    get review_student_submissions_previous_url
    assert_response :success
  end

  test "should get tag_student_submission" do
    get review_student_submissions_tag_student_submission_url
    assert_response :success
  end
end
