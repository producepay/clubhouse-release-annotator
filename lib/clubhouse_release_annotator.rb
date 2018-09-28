# frozen_string_literal: true

require 'clubhouse_release_annotator/version'
require 'clubhouse_release_annotator/config'
require 'clubhouse_release_annotator/repository'
require 'clubhouse_release_annotator/stories_info'
require 'clubhouse_release_annotator/formatter'

module ClubhouseReleaseAnnotator
  # Command-line instance
  class CLI
    def self.run # rubocop:disable Metrics/MethodLength
      repo = Repository.new
      story_numbers = repo.referenced_stories.sort_by(&:to_i)

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
