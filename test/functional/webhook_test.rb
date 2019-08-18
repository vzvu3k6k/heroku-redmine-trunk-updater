require_relative '../test_helper'

class TrunkUpdaterControllerTest < ActionDispatch::IntegrationTest
  setup do
    @original_env = ENV.to_h
    ENV['REDMINE_TRUNK_UPDATER_TOKEN'] = 'foobar'
  end

  teardown do
    ENV.replace(@original_env)
  end

  test 'when token is invalid' do
    TrunkUpdater::SelfRepository.expects(:update_image_tag).never
    post update_webhook_path(token: 'INVALID')
    assert_response :bad_request
    assert_equal "Can't verify your request", response.body
  end

  test 'when token is valid but tag is unknown' do
    TrunkUpdater::SelfRepository.expects(:update_image_tag).never
    post update_webhook_path(token: 'foobar', push_data: { tag: 'latest' })
    assert_response :ok
    assert_equal 'Unknown image tag', response.body
  end

  test 'when token is valid and tag is known' do
    TrunkUpdater::SelfRepository
      .expects(:update_image_tag)
      .with('git@github.com:vzvu3k6k/heroku-redmine-trunk.git', 'r456')
      .once
    post update_webhook_path(token: 'foobar', push_data: { tag: 'r456' })
    assert_response :ok
    assert_equal 'Update to r456', response.body
  end
end
