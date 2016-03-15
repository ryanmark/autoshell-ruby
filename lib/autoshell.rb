require 'logger'

require 'autoshell/run'
require 'autoshell/environment'
require 'autoshell/filestuff'
require 'autoshell/git'
require 'autoshell/log'

# The top-level namespace of the Autoshell lib
#
#
module Autoshell
  # These vars are copied from the ruby script's environment
  ALLOWED_ENV = %w(PATH LANG USER LOGNAME LC_CTYPE LD_LIBRARY_PATH ARCHFLAGS
                   TMPDIR SSH_AUTH_SOCK HOME)

  # Default log formatter
  LOG_FORMATTER = proc { |_s, _d, _p, msg| msg }

  # Default log level
  LOG_LEVEL = Logger::DEBUG # WARN

  # Exception thrown by autoshell methods when a command fails
  #
  #   sh = Autoshell.new
  #   begin
  #     sh.run 'missing-command'
  #   rescue Autoshell::CommandError => exc
  #     puts 'command failed!'
  #   end
  class CommandError < StandardError; end

  class << self
    # Create a new autoshell. Same as `Autoshell::Base.new`.
    # @see Autoshell::Base#initialize
    def new(path = '.', env: {}, logger: nil)
      Base.new(path, env: env, logger: logger)
    end
    alias_method :open, :new
  end

  # The core autoshell class
  # @!attribute env
  #   @return [Hash] environment variables in this shell
  # @!attribute working_dir
  #   @return [String] current working directory of this shell
  # @!attribute home_dir
  #   @return [String] directory this shell was started with
  class Base
    include Autoshell::Run
    include Autoshell::Filestuff
    include Autoshell::Environment
    include Autoshell::Git
    include Autoshell::Log

    attr_accessor :env, :working_dir
    alias_method :to_s, :working_dir

    # Create a new shell object with a working directory and environment vars
    #
    # @param path [String] Create a new shell at this path
    # @option env [Hash] :env Environment variables to add to this shell
    # @option logger [Logger] :logger Logger instance to use
    def initialize(path = '.', env: {}, logger: nil)
      # save the working directory
      self.working_dir = File.expand_path(path.to_s)
      # Load whitelisted environment variables
      self.env = ENV.select { |k, _| ALLOWED_ENV.include? k }
      # Set some defaults
      self.env['SHELL'] = '/bin/bash'
      # Update environment variables from option
      self.env.update env
      # did we get a logger to use?
      self.logger = logger if logger
    end
  end
end
