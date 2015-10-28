require 'ansi/code'
require 'open3'

module Autoshell
  # Execution stuff
  module Run
    # Wrapper around Open3.capture2e
    #
    # @see Open3#capture2e
    # @return [String] command output
    # @raise [CommandError] if the command fails
    def run(*args, **opts)
      # reset all environment variables...
      opts[:unsetenv_others] = true unless opts.keys.include? :unsetenv_others

      # run the command
      out, status = Open3.capture2e(@env, *args, **opts)

      # cleanup output
      out.strip!

      # the prompt
      msg = "#{prompt_ansi(args)}\n#{out}"

      if status.success?
        logger.debug msg
        return out
      else
        logger.error msg
        raise CommandError, "#{prompt_text(args)}\n#{out}"
      end
    end

    # Check if a command is available
    #
    # @param cmd [String] Name of the command
    # @return [String] Path to the command
    # @return [False] If command does not exist
    def command?(cmd)
      run('which', cmd.to_s)
    rescue CommandError
      return false
    end

    private

    # Render a prompt string for logging
    #
    # @private
    # @param cmd [Array<String>] array of command parts
    # @return [String] ansi formatted string
    def prompt_ansi(cmd)
      "#{ANSI.blue(working_dir)} $ #{ANSI.white(cmd.join(' '))}"
    end

    # Render a prompt string for logging
    #
    # @private
    # @param cmd [Array<String>] array of command parts
    # @return [String] plain text string
    def prompt_text(cmd)
      ANSI.unansi(prompt_ansi(cmd))
    end
  end
end
