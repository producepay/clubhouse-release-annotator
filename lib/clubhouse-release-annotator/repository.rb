require 'git'
require 'logger'

module ClubhouseReleaseAnnotator
  # Your code goes here
  class Repository
    attr_reader :referenced_tickets, :last_release, :annotated, :unannotated

    def initialize
      @repo ||= Git.open('.')
      parse_commits
    end

    private
      def last_release
        @last_release ||= @repo.tags.last
      end

      def parse_commits
        if last_release
          commits = @repo.log(Config.instance.max_commits).between(last_release.name, "HEAD")
        else
          commits = @repo.log(Config.instance.max_commits)
        end
        @annotated, @unannotated = *(commits.partition{ |com| com.message =~ /\[branch ch\d+\]/})
        @referenced_tickets = @annotated.reduce([]) do |accumulator, commit|
          accumulator += commit.message.scan(/\[branch ch(\d+)\]/).map(&:last)
        end.uniq
      end
  end
end
