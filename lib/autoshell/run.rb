require 'ansi/code'
require 'open3'

module Autoshell
  # Execution stuff
  # @!attribute branch
  #   @return [Hash] (master) branch of the current repo
  module Run
    # Wrapper around Open3.capture2e
    # @param (see Open3#capture2e)
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

    def command?(cmd)
      run('which', cmd.to_s)
    rescue CommandError
      return false
    end

    private

    # Render a prompt string for logging
    #
    # @param cmd [Array] array of command parts
    # @return [String] ansi formatted string
    def prompt_ansi(cmd)
      "#{ANSI.blue(working_dir)} $ #{ANSI.white(cmd.join(' '))}"
    end

    # Render a prompt string for logging
    #
    # @param cmd [Array] array of command parts
    # @return [String] plain text string
    def prompt_text(cmd)
      ANSI.unansi(prompt_ansi(cmd))
    end
  end
end
