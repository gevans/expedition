module Expedition
  class Status

    SEVERITIES = {
      'S' => :success,
      'I' => :info,
      'W' => :warning,
      'E' => :error,
      'F' => :fatal
    }.freeze

    OK_SEVERITIES = %i(success info warning).freeze

    attr_reader :severity

    attr_reader :code

    attr_reader :message

    attr_reader :description

    attr_reader :executed_at

    def initialize(body)
      status = body.try(:first) || {}

      @severity    = SEVERITIES[status[:status]]
      @code        = status[:code]
      @message     = status[:msg]
      @description = status[:description]
      @executed_at = Time.at(status[:when]) rescue nil
    end

    def success?
      severity == :success
    end

    def info?
      severity == :info
    end

    def warning?
      severity == :warning
    end

    def error?
      severity == :error
    end

    def fatal?
      severity == :fatal
    end

    def ok?
      OK_SEVERITIES.include?(severity)
    end
  end
end # Expedition
