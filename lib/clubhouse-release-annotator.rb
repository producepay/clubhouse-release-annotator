require "clubhouse-release-annotator/version"
require "clubhouse-release-annotator/repository"

module ClubhouseReleaseAnnotator
  class CLI
    def self.run
      puts "release annotator running"
      repo = Repository.new
      require 'pp'

      pp repo.tickets
    end
  end
  # Your code goes here
end
