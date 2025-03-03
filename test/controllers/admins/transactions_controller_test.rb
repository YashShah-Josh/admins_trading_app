require "test_helper"

class Admins::TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_transactions_index_url
    assert_response :success
  end

  test "should get show" do
    get admins_transactions_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admins_transactions_destroy_url
    assert_response :success
  end
end
