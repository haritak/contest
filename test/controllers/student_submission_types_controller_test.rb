require "test_helper"

class StudentSubmissionTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_submission_type = student_submission_types(:one)
  end

  test "should get index" do
    get student_submission_types_url
    assert_response :success
  end

  test "should get new" do
    get new_student_submission_type_url
    assert_response :success
  end

  test "should create student_submission_type" do
    assert_difference("StudentSubmissionType.count") do
      post student_submission_types_url, params: { student_submission_type: { accepted_filetype: @student_submission_type.accepted_filetype, description: @student_submission_type.description, max_submissions: @student_submission_type.max_submissions, name: @student_submission_type.name, optional: @student_submission_type.optional } }
    end

    assert_redirected_to student_submission_type_url(StudentSubmissionType.last)
  end

  test "should show student_submission_type" do
    get student_submission_type_url(@student_submission_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_submission_type_url(@student_submission_type)
    assert_response :success
  end

  test "should update student_submission_type" do
    patch student_submission_type_url(@student_submission_type), params: { student_submission_type: { accepted_filetype: @student_submission_type.accepted_filetype, description: @student_submission_type.description, max_submissions: @student_submission_type.max_submissions, name: @student_submission_type.name, optional: @student_submission_type.optional } }
    assert_redirected_to student_submission_type_url(@student_submission_type)
  end

  test "should destroy student_submission_type" do
    assert_difference("StudentSubmissionType.count", -1) do
      delete student_submission_type_url(@student_submission_type)
    end

    assert_redirected_to student_submission_types_url
  end
end
