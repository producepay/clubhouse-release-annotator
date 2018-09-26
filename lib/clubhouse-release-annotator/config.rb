require 'singleton'

module ClubhouseReleaseAnnotator
  # Your code goes here
  class Config
    include Singleton

    DEFAULTS = {
      max_commits: 1000
    }
    def initialize
      @config = DEFAULTS.clone
      @config[:clubhouse_api_token] = get_clubhouse_api_token
    end

    def get_clubhouse_api_token
      @token ||= ENV["CLUBHOUSE_API_TOKEN"] ||  get_clubhouse_api_token_from_file
      unless @token
        raise MissingConfigException.new("Please provide a ClubHouse API token.  See README for details.")
      end
      @token
    end

    def get_clubhouse_api_token_from_file
      ['~/.clubhouse_api_token', './.clubhouse_api_token'].find do |fname|
        # File.exists?(fname)
        nil
      end
    end

    class MissingConfigException < Exception
    end
  end
end
