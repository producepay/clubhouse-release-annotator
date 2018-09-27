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
        # p "searching since last release #{last_release.name}"
        if last_release
          commits = @repo.log(Config.instance.max_commits).between(last_release.name, "HEAD")
        else
          commits = @repo.log(Config.instance.max_commits)
        end
        puts "found #{commits.count} commits"
        @annotated, @unannotated = *(commits.partition{ |com| com.message =~ /\[branch ch\d+\]/})
        # p @annotated.map(&:message)
        @referenced_tickets = @annotated.reduce([]) do |accumulator, commit|
          # p commit.message.scan(/\[branch ch(\d+)\]/).map(&:last)
          accumulator += commit.message.scan(/\[branch ch(\d+)\]/).map(&:last)
        end.uniq
      end
  end
end
