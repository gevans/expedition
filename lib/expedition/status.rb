module Expedition
  class Status

    SEVERITIES = {
      'S' => :success,
      'I' => :info,
      'W' => :warn,
      'E' => :error,
      'F' => :fatal
    }.freeze

    OK_SEVERITIES = %i(success info warn).freeze

    attr_reader :severity

    attr_reader :code

    attr_reader :message

    attr_reader :description

    attr_reader :executed_at

    def initialize(body)
      status = body ? body.first : {}

      @severity    = SEVERITIES[status['STATUS']]
      @code        = status['Code']
      @message     = status['Msg']
      @description = status['Description']
      @executed_at = Time.at(status['When']) rescue nil
    end

    def success?
      severity == :success
    end

    def info?
      severity == :info
    end

    def warn?
      severity == :warn
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
