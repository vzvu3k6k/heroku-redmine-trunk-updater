require_relative '../test_helper'

class TrunkUpdaterControllerTest < ActionDispatch::IntegrationTest
  setup do
    @original_env = ENV.to_h
    ENV['REDMINE_TRUNK_UPDATER_TOKEN'] = 'foobar'
  end

  teardown do
    ENV.replace(@original_env)
  end

  test 'should return 400 if token is invalid' do
    post update_webhook_path(token: 'INVALID')
    assert_response :bad_request
  end

  test 'should return 200 if token is valid' do
    post update_webhook_path(token: 'foobar')
    assert_response :ok
  end
end
