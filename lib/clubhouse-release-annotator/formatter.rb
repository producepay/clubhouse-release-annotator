
module ClubhouseReleaseAnnotator
  class Formatter
    def initialize(stories)
      @stories = stories
    end

    def format
      "".tap do |str|
        str << '## ' + Time.now.strftime("%Y-%m-%d")
        str << "\n\n"
        @stories.each do |story|
          str << "* [#{story.id} #{story.name}](https://app.clubhouse.io/story/#{story.id})\n"
        end
      end
    end
  end
end
