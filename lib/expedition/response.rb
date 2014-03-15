require 'hashie'

require 'expedition/status'

module Expedition
  class Response

    attr_reader :body

    attr_reader :raw

    attr_reader :status

    def self.parse(raw)
      new(normalize(raw), raw)
    end

    def initialize(normalized, raw)
      @body = normalized
      @raw = raw
      @status = Status.new(normalized[:status])
    end

    delegate :success?, :informational?, :warning?, :error?, :fatal?,
             :executed_at, to: :status

    delegate :[], :to_hash, to: :body

    def respond_to_missing?(method_name, include_private = false)
      body.has_key?(method_name) || super
    end

    def method_missing(method_name, *arguments, &block)
      if respond_to_missing?(method_name)
        body[method_name]
      else
        super
      end
    end

    private

    def self.normalize(value)
      case value
      when Hash
        Hash[value.collect { |k, v| [normalize_key(k), normalize(v)] }]
      when Array
        value.collect { |v| normalize(v) }
      else
        value
      end
    end

    def self.normalize_key(key)
      key.gsub(/(\w)%/, '\\1_percent').gsub('%', 'percent').gsub(/\s/, '_').downcase.to_sym
    end
  end # Response
end # Expedition
