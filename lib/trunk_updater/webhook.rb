module TrunkUpdater
  # Handles a Docker Hub webhook request
  class Webhook
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def valid?
      params[:token] == ENV['REDMINE_TRUNK_UPDATER_TOKEN']
    end

    def tag
      params.dig(:push_data, :tag)
    end
  end
end
