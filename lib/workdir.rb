require 'fileutils'
require 'mime/types'
require 'open3'

require 'workdir/environment'
require 'workdir/file'
require 'workdir/git'

# Thin API for doing shell stuff
class WorkDir
  include File
  include Environment
  include Git

  # These vars are allowed to leak through to commands run in the working dir
  ALLOWED_ENV = %w(
    PATH LANG USER LOGNAME LC_CTYPE SHELL LD_LIBRARY_PATH ARCHFLAGS TMPDIR
    SSH_AUTH_SOCK HOME)

  class CommandError < StandardError; end

  attr_accessor :logger
  attr_accessor :env

  # Create a new shell object with a working directory and environment vars
  def initialize(path, env = {})
    @working_dir = path.to_s
    @env = ENV.select { |k, _| WorkDir::ALLOWED_ENV.include? k }
    @env.update env
  end

  # Wrapper around Open3.capture2e
  def run(*args, **opts, &block)
    opts[:unsetenv_others] = true unless opts.keys.include? :unsetenv_others
    logger.debug((@env.map { |k, v| "#{k}=#{v}" } + args).join(' '))
    out, status = Open3.capture2e(@env, *args, **opts, &block)
    return out if status.success?
    raise CommandError, "#{args.join(' ')}\n#{out}"
  end

  def to_s
    @working_dir
  end
end
