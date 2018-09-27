require "clubhouse-release-annotator/version"
require "clubhouse-release-annotator/config"
require "clubhouse-release-annotator/repository"

module ClubhouseReleaseAnnotator
  class CLI
    def self.run
      puts "release annotator running"
      config = Config.instance

      repo = Repository.new
      require 'pp'
      # p :api_token => config.clubhouse_api_token
      p config
      pp repo.tickets
    rescue ClubhouseReleaseAnnotator::Config::MissingConfigException => ex
      puts ex.message
      exit(1)
    end
  end
end
