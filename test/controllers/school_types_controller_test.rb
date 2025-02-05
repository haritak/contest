require "test_helper"

class SchoolTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school_type = school_types(:one)
  end

  test "should get index" do
    get school_types_url
    assert_response :success
  end

  test "should get new" do
    get new_school_type_url
    assert_response :success
  end

  test "should create school_type" do
    assert_difference("SchoolType.count") do
      post school_types_url, params: { school_type: { school_type: @school_type.school_type } }
    end

    assert_redirected_to school_type_url(SchoolType.last)
  end

  test "should show school_type" do
    get school_type_url(@school_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_school_type_url(@school_type)
    assert_response :success
  end

  test "should update school_type" do
    patch school_type_url(@school_type), params: { school_type: { school_type: @school_type.school_type } }
    assert_redirected_to school_type_url(@school_type)
  end

  test "should destroy school_type" do
    assert_difference("SchoolType.count", -1) do
      delete school_type_url(@school_type)
    end

    assert_redirected_to school_types_url
  end
end
