class TrunkUpdaterController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    if params[:token] == ENV['REDMINE_TRUNK_UPDATER_TOKEN']
      head :ok
    else
      head :bad_request
    end
  end
end
