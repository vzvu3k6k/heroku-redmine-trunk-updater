class TrunkUpdaterController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    webhook = TrunkUpdater::Webhook.new(params)

    unless webhook.valid?
      render status: :bad_request, body: "Can't verify your request"
      return
    end

    unless webhook.tag.match?(/^r\d+$/)
      render body: 'Unknown image tag'
      return
    end

    TrunkUpdater::SelfRepository.update_container(
      'git@github.com:vzvu3k6k/heroku-redmine-trunk.git',
      webhook.tag
    )
    render body: "Update to #{webhook.tag}"
  end
end
