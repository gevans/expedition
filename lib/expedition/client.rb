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
    def send(command, *parameters)
      socket = TCPSocket.new(host, port)
      socket.puts command_json(command, *parameters)

      parse(socket.gets)
    ensure
      socket.close if socket.respond_to?(:close)
    end

    alias method_missing send

    private

    def parse(response)
      Response.parse(MultiJson.load(response.chomp("\x0")))
    end

    def command_json(command, *parameters)
      MultiJson.dump(command: command, parameter: parameters.join(','))
    end
  end # Client
end # Expedition
