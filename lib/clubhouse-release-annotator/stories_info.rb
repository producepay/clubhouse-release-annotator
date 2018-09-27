require 'clubhouse2'

module ClubhouseReleaseAnnotator
  class StoriesInfo
    attr_reader :stories

    def initialize(story_numbers)
      @story_numbers = story_numbers
      @client = Clubhouse::Client.new(api_key: Config.instance.clubhouse_api_token)
      fetch_stories
    end

    private
      def fetch_stories
        @stories = @story_numbers.map do |number|
          @client.story(id: number.to_i)
        end
      end
    end
end
