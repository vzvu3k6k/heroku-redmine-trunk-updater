class TrunkUpdaterController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    head :bad_request
  end
end
