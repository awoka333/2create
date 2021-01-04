require 'test_helper'

class ThemesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get themes_edit_url
    assert_response :success
  end

end
