require 'active_support'
require 'active_support/core_ext'

require 'expedition/client'
require 'expedition/version'

module Expedition

  ##
  # Initializes a new {Expedition::Client}.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Integer] port
  #   The port to connect to.
  #
  # @return [Client]
  #   A client for accessing the API of a cgminer-compatible service.
  def self.new(host = 'localhost', port = 4028)
    Client.new(host, port)
  end

  ##
  # Returns the default client for connection to `localhost` on port `4028`.
  # Used for simple scripts that access the `Expedition` constant directly.
  #
  # @return [Client]
  #   The default client.
  def self.client
    @client ||= new
  end
end # Expedition
