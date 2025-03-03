require "test_helper"

class Admins::UserStocksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_user_stocks_index_url
    assert_response :success
  end

  test "should get show" do
    get admins_user_stocks_show_url
    assert_response :success
  end
end
