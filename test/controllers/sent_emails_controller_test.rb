require "test_helper"

class SentEmailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sent_emails_index_url
    assert_response :success
  end
end
