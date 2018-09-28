# frozen_string_literal: true

require 'clubhouse2'

module ClubhouseReleaseAnnotator
  # Fetcher / organizer for Clubhouse stories
  class StoriesInfo

    def initialize(story_numbers)
      @story_numbers = story_numbers
      @client = Clubhouse::Client.new(api_key: Config.instance.clubhouse_api_token)
      fetch_stories
    end

    def stories
      @stories ||= fetch_stories.compact
    end

    private

    def fetch_stories
      @story_numbers.map do |number|
        story = @client.story(id: number.to_i)
        warn_no_story(number) if !story
        story
      end
    end

    def warn_no_story(number)
      STDERR.puts "WARNING: Story reference found for a clubhouse story that does not " +
                  "exist (#{number})."
    end
  end
end
