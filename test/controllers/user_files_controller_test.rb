require "test_helper"

class UserFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get user_files_show_url
    assert_response :success
  end
end
