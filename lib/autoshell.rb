require 'logger'

require 'autoshell/run'
require 'autoshell/environment'
require 'autoshell/filestuff'
require 'autoshell/git'
require 'autoshell/log'

# Thin API for doing shell stuff
module Autoshell
  # These vars are allowed to leak through to commands run in the working dir
  ALLOWED_ENV = %w(
    PATH LANG USER LOGNAME LC_CTYPE LD_LIBRARY_PATH ARCHFLAGS TMPDIR
    SSH_AUTH_SOCK HOME)

  LOG_FORMATTER = proc { |_s, _d, _p, msg| msg }
  # LOG_LEVEL = Logger::WARN
  LOG_LEVEL = Logger::DEBUG

  class CommandError < StandardError; end

  class << self
    def new(path = '.', env = {})
      Base.new(path, env)
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
    # @param path [String] Create a new shell at this path
    # @option env [Hash] :env Environment variables to add to this shell
    # @option logger [Logger] :logger Logger instance to use
    def initialize(path = '.', env: {}, logger: nil)
      # save the working directory
      self.working_dir = File.expand_path(path.to_s)
      # Load whitelisted environment variables
      self.env = ENV.select { |k, _| ALLOWED_ENV.include? k }
      # Set some defaults
      env['SHELL'] = '/bin/bash'
      # Update environment variables from option
      env.update env
      # did we get a logger to use?
      self.logger = logger if logger
    end
  end
end
