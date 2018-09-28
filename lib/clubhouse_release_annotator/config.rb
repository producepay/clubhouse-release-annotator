# frozen_string_literal: true

require 'singleton'
require 'ostruct'

module ClubhouseReleaseAnnotator
  # Singleton configuration for the gem
  class Config < OpenStruct
    include Singleton

    DEFAULTS = {
      max_commits: 1000
    }.freeze
    def initialize
      super(DEFAULTS)
      self[:clubhouse_api_token] = get_clubhouse_api_token
      self[:repo_directory] = Dir.pwd
    end

    def clubhouse_api_token
      @token ||= ENV['CLUBHOUSE_API_TOKEN'] || read_clubhouse_api_token_from_file
      unless @token
        raise MissingConfigException,
              'Please provide a ClubHouse API token.  See README for details.'
      end

      @token
    end

    LOOKUP_LOCATIONS = ['~/.clubhouse_api_token', './.clubhouse_api_token'].map do |fname|
      File.expand_path(fname)
    end

    def read_clubhouse_api_token_from_file
      api_file = LOOKUP_LOCATIONS.find do |path|
        File.exist?(path)
      end
      File.read(api_file).strip if api_file
    end

    class MissingConfigException < RuntimeError
    end
  end
end
