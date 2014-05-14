require 'multi_json'
require 'socket'

require 'expedition/response'

module Expedition
  class Client

    ##
    # @return [String]
    #   The host this client will execute commands on.
    attr_accessor :host

    ##
    # @return [Integer]
    #   The host port this client will connect to.
    attr_accessor :port

    ##
    # Initializes a new `Client` for executing commands.
    #
    # @param [String] host
    #   The host to connect to.
    #
    # @param [Integer] port
    #   The port to connect to.
    def initialize(host = 'localhost', port = 4028)
      @host = host
      @port = port
    end

    def devices
      send(:devdetails) do |body|
        body[:devdetails].collect { |attrs|
          attrs.delete(:devdetails)
          attrs[:variant] = attrs.delete(:name).downcase
          attrs
        }
      end
    end

    def metrics
      send(:devs) do |body|
        body[:devs].collect(&method(:parse_metrics))
      end
    end

    def pools
      send(:pools) do |body|
        body[:pools].collect(&method(:parse_pool))
      end
    end

    ##
    # Sends the supplied `command` with optionally supplied `parameters` to the
    # service and returns the result, if any.
    #
    # **Note:** Since `Object#send` is overridden, use `Object#__send__` to call
    # an actual method.
    #
    # @param [Symbol, String] command
    #   The command to send to the service.
    #
    # @param [Array] parameters
    #   Optional parameters to send to the service.
    #
    # @return [Response]
    #   The service's response.
    def send(command, *parameters, &block)
      socket = TCPSocket.new(host, port)
      socket.puts command_json(command, *parameters)

      parse(socket.gets, &block)
    ensure
      socket.close if socket.respond_to?(:close)
    end

    alias_method :method_missing, :send

    private

    def parse(response, &block)
      Response.parse(MultiJson.load(response.chomp("\x0")), &block)
    end

    def command_json(command, *parameters)
      MultiJson.dump(command: command, parameter: parameters.join(','))
    end

    def parse_metrics(attrs)
      attrs.merge!(
        enabled: attrs[:enabled] == 'Y',
        status: attrs[:status].downcase,
        last_share_time: (Time.at(attrs[:last_share_time]) rescue attrs[:last_share_time]),
        last_valid_work: (Time.at(attrs[:last_valid_work]) rescue attrs[:last_valid_work])
      )

      interval = attrs.keys.detect { |k| k =~ /^mhs_\d+s$/ }[/\d+s$/]

      # Remove the `_Ns` suffix from hash rate fields.
      attrs.merge!(
        mhs: attrs.delete("mhs_#{interval}"),
        khs: attrs.delete("khs_#{interval}")
      )
    end

    def parse_pool(attrs)
      attrs.merge!(
        status: attrs[:status].downcase,
        long_poll: attrs[:long_poll] != 'N',
        last_share_time: (Time.at(attrs[:last_share_time]) rescue attrs[:last_share_time]),
      )
    end
  end # Client
end # Expedition
