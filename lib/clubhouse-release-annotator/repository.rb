# frozen_string_literal: true

require 'git'
require 'logger'

module ClubhouseReleaseAnnotator
  class Repository
    attr_reader :annotated, :unannotated

    def initialize
      @repo ||= Git.open(Config.instance.repo_directory)
    end

    def last_release
      @last_rel ||= @repo.tags.last
    end

    def referenced_stories
      @ref_stories ||= parse_commits
    end

    private

    def commits
      @repo.log(Config.instance.max_commits)
    end

    def relevant_commits
      if last_release
        commits.between(last_release.name, 'HEAD')
      else
        commits
      end
    end

    def parse_commits
      @annotated, @unannotated = *(relevant_commits.partition { |com| com.message =~ /\[branch ch\d+\]/ })
      @annotated.reduce([]) do |accumulator, commit|
        accumulator += commit.message.scan(/\[branch ch(\d+)\]/).map(&:last)
      end.uniq
    end
  end
end
