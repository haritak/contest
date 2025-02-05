require "test_helper"

class StudentFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get student_files_show_url
    assert_response :success
  end
end
