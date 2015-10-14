require 'logger'
require 'stringio'

module Autoshell
  module Log
    attr_accessor :color

    # Instance-specific logger
    #
    #   shell = Autoshell.new '~/test'
    #   shell.logger
    #
    #   shell.logger = Rails.logger
    #
    # @return [Logger] logger instance
    def logger
      return @logger if @logger

      @color = true
      @log_device = StringIO.new
      @logger = Logger.new(@log_device)
      @logger.level = LOG_LEVEL
      @logger.formatter = LOG_FORMATTER
      @logger
    end
    attr_writer :logger

    # Get the complete output of the log
    # @return [String] log contents
    def log_output
      return unless @log_device
      if color
        @log_device.string
      else
        strip_ansi(@log_device.string)
      end
    end

    # Reset the log contents
    # @return self
    def log_reset
      @log_device.truncate(0) if @log_device
      self
    end
  end
end
