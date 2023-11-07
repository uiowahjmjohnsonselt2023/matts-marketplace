require "test_helper"

class BuyControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get buy_index_url
    assert_response :success
  end
end
