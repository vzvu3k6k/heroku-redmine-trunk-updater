require_relative '../test_helper'

class TrunkUpdaterControllerTest < ActionDispatch::IntegrationTest
  test 'should return 400 if token is invalid' do
    post update_webhook_path(token: 'INVALID')
    assert_response :bad_request
  end
end
