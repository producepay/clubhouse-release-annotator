require 'clubhouse2'

module ClubhouseReleaseAnnotator
  class TicketsInfo
    attr_reader :tickets

    def initialize(ticket_numbers)
      @ticket_numbers = ticket_numbers
      @client = Clubhouse::Client.new(api_key: Config.instance.clubhouse_api_token)
      fetch_tickets
    end

    private
      def fetch_tickets
        @tickets = @ticket_numbers.map do |number|
          @client.story(id: number.to_i)
        end
      end
    end
end
