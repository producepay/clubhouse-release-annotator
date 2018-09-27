require "clubhouse-release-annotator/version"
require "clubhouse-release-annotator/config"
require "clubhouse-release-annotator/repository"
require "clubhouse-release-annotator/stories_info"
require "clubhouse-release-annotator/formatter"
require "byebug"

module ClubhouseReleaseAnnotator
  class CLI
    def self.run
      config = Config.instance
      repo = Repository.new
      story_numbers = repo.referenced_stories
      if story_numbers.empty?
        puts "No clubhouse stories found in this repository since the last tag #{repo.last_release}"
      else
        info = StoriesInfo.new(story_numbers)
        puts Formatter.new(info.stories).format
      end

    rescue ClubhouseReleaseAnnotator::Config::MissingConfigException => ex
      puts ex.message
      exit(1)
    end
  end
end
