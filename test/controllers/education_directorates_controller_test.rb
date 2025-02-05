require "test_helper"

class EducationDirectoratesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @education_directorate = education_directorates(:one)
  end

  test "should get index" do
    get education_directorates_url
    assert_response :success
  end

  test "should get new" do
    get new_education_directorate_url
    assert_response :success
  end

  test "should create education_directorate" do
    assert_difference("EducationDirectorate.count") do
      post education_directorates_url, params: { education_directorate: { name: @education_directorate.name } }
    end

    assert_redirected_to education_directorate_url(EducationDirectorate.last)
  end

  test "should show education_directorate" do
    get education_directorate_url(@education_directorate)
    assert_response :success
  end

  test "should get edit" do
    get edit_education_directorate_url(@education_directorate)
    assert_response :success
  end

  test "should update education_directorate" do
    patch education_directorate_url(@education_directorate), params: { education_directorate: { name: @education_directorate.name } }
    assert_redirected_to education_directorate_url(@education_directorate)
  end

  test "should destroy education_directorate" do
    assert_difference("EducationDirectorate.count", -1) do
      delete education_directorate_url(@education_directorate)
    end

    assert_redirected_to education_directorates_url
  end
end
