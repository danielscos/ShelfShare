require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get admin_dashboard_url
    assert_response :success
  end

  test "should get users" do
    get admin_users_url
    assert_response :success
  end

  test "should get books" do
    get admin_books_url
    assert_response :success
  end
end
