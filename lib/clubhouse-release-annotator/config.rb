require 'singleton'
require 'ostruct'

module ClubhouseReleaseAnnotator
  class Config < OpenStruct
    include Singleton

    DEFAULTS = {
      max_commits: 1000
    }
    def initialize
      super(DEFAULTS)
      self[:clubhouse_api_token] = get_clubhouse_api_token
      self[:repo_directory] = Dir.pwd
    end

    def get_clubhouse_api_token
      @token ||= ENV["CLUBHOUSE_API_TOKEN"] ||  get_clubhouse_api_token_from_file
      unless @token
        raise MissingConfigException.new("Please provide a ClubHouse API token.  See README for details.")
      end
      @token
    end

    LOOKUP_LOCATIONS = ['~/.clubhouse_api_token', './.clubhouse_api_token'].map{|f| File.expand_path(f)}
    def get_clubhouse_api_token_from_file
      api_file = LOOKUP_LOCATIONS.find do |path|
        File.exists?(path)
      end
      File.read(api_file).strip if api_file
    end

    class MissingConfigException < Exception
    end
  end
end
