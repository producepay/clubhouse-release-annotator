require "clubhouse-release-annotator/version"
require "clubhouse-release-annotator/config"
require "clubhouse-release-annotator/repository"
require "clubhouse-release-annotator/tickets_info"

module ClubhouseReleaseAnnotator
  class CLI
    def self.run
      config = Config.instance
      repo = Repository.new
      ticket_numbers = repo.referenced_tickets
      if ticket_numbers.empty?
        puts "No clubhouse tickets found in this repository since the last tag #{repo.last_release}"
      else
        info = TicketsInfo.new(ticket_numbers)
        puts "Found tickets:"
        puts info.tickets.map{ |t| "#{t.id} #{t.name}" }
      end

    rescue ClubhouseReleaseAnnotator::Config::MissingConfigException => ex
      puts ex.message
      exit(1)
    end
  end
end
