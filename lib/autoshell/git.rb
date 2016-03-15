require 'fileutils'

module Autoshell
  # Git repo stuff
  # @!attribute branch
  #   @return [String] (master) branch of the current repo
  module Git
    def branch
      @branch ||= git? ? git('rev-parse', '--abbrev-ref', 'HEAD') : 'master'
    end
    attr_writer :branch

    # Has this repo been cloned to disk?
    #
    # @return [Boolean] True if this dir is a cloned repo
    def git?
      dir? '.git'
    end

    # Update the repo on disk
    #
    # @return [String] Output of git commands
    def update
      [
        git('checkout', working_dir),
        git('clean', '-fd'),
        git('checkout', 'master'),
        git('pull', '--recurse-submodules=yes'),
        git('fetch', 'origin'),
        git('checkout', branch),
        git('submodule', 'update', '--init')
      ].join("\n")
    end

    # Checkout a different branch
    #
    # @param [String] Branch name
    # @return [String] Output of git commands
    def switch(new_branch)
      self.branch = new_branch
      update
    end

    # Clone a repo to disk from the url
    #
    # @param [String] Git repository URL
    # @return [String] Output of git commands
    def clone(repo_url)
      mkpdir working_dir
      run 'git', 'clone', '--recursive', repo_url, working_dir
    end

    # Get the current commit hash
    #
    # @param [String] (HEAD) Branch or tag
    # @return [String] Git commit hash
    def commit_hash(branch_or_tag = nil)
      @version = git 'rev-parse', branch_or_tag || 'HEAD'
    end
    alias_method :version, :commit_hash

    # Get a tar archive of the repo as a string
    #
    # @param [String] (HEAD) Branch or tag
    # @return [String] Zip-formatted binary string
    def archive(branch_or_tag = nil)
      git 'archive', branch_or_tag || 'HEAD', binmode: true
    end

    # Run a git command
    #
    # @param [*Array<String>] Command
    # @return [String] Command output
    def git(*args)
      cd { run(*['git'] + args) }
    end
  end
end
