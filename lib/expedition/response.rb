require 'active_support/core_ext/hash/indifferent_access'

require 'expedition/status'

module Expedition
  class Response

    attr_reader :body

    attr_reader :raw

    attr_reader :status

    def self.parse(raw)
      normalized = normalize(raw)
      normalized = yield normalized if block_given?
      new(normalized, raw)
    end

    def initialize(normalized, raw)
      @body   = normalized
      @raw    = raw
      @status = Status.new(raw['STATUS'])
    end

    delegate :success?, :info?, :warn?, :error?, :fatal?, :ok?,
             :executed_at, to: :status

    delegate :[], :to_h, :to_hash, :to_a, :to_ary, to: :body

    def respond_to_missing?(method_name, include_private = false)
      body.respond_to?(method_name) || super
    end

    def method_missing(method_name, *arguments, &block)
      if respond_to_missing?(method_name)
        body.send(method_name, *arguments, &block)
      else
        super
      end
    end

    private

    def self.normalize(value)
      case value
      when Hash
        Hash[value.collect { |k, v| [normalize_key(k), normalize(v)] }].with_indifferent_access
      when Array
        value.collect { |v| normalize(v) }
      else
        value
      end
    end

    def self.normalize_key(key)
      key = key.gsub(/(\w)%/, '\\1_percent').gsub('%', 'percent').gsub(/[^\w]+/, ' ')
      key.strip.gsub(/\s+/, '_').downcase
    end
  end # Response
end # Expedition
