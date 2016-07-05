require 'fileutils'

module Autoshell
  # Git repo stuff
  # @!attribute branch
  #   @return [String] (master) branch of the current repo
  module Git
    def branch
      @branch ||= 'master'
    end
    attr_writer :branch

    # Set the branch from a repo url
    #
    # @param [String] Git repository URL
    # @return [string] Branch name
    def branch_from_repo_url(repo_url)
      if repo_url =~ /#\S+[^\/]/
        @branch = repo_url.split('#')[1]
      else
        @branch = 'master'
      end
    end

    def commit_hash_for_checkout
      @commit_hash_for_checkout ||= 'HEAD'
    end
    attr_writer :commit_hash_for_checkout

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
        git('checkout', '.'),
        git('clean', '-ffd'),
        git('checkout', branch),
        git('pull', '--recurse-submodules=yes'),
        git('fetch', 'origin'),
        git('checkout', commit_hash_for_checkout),
        git('submodule', 'update', '--init'),
        git('clean', '-ffd')
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
      run 'git', 'clone', '--recursive', repo_url.split('#')[0], working_dir
      branch_from_repo_url(repo_url)
      update
    end

    # Checkout a specific hash on the repo
    #
    # @param [String] Git version hash
    # @return [String] Output of git commands
    def checkout_version(version_hash)
      git 'checkout', version_hash || 'HEAD'
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
