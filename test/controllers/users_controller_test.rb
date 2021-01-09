require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_up" do
    get users_sign_up_url
    assert_response :success
  end

  test "should get login" do
    get users_login_url
    assert_response :success
  end

  test "should get index" do
    get users_index_url
    assert_response :success
  end

  test "should get show" do
    get users_show_url
    assert_response :success
  end

end
