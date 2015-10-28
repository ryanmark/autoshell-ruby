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
    def git?
      dir? '.git'
    end

    # Update the repo on disk
    def update
      git 'checkout', working_dir
      git 'clean', '-fd'
      git 'checkout', 'master'
      git 'pull', '--recurse-submodules=yes'
      git 'fetch', 'origin'
      git 'checkout', branch
      git 'submodule', 'update', '--init'
    end

    # Checkout a different branch
    def switch(new_branch)
      self.branch = new_branch
      update
    end

    # Clone a repo to disk from the url
    def clone(repo_url)
      mkpdir working_dir
      run 'git', 'clone', '--recursive', repo_url, working_dir
    end

    # Get the current commit hash
    def commit_hash(branch_or_tag = nil)
      @version = git 'rev-parse', branch_or_tag || 'HEAD'
    end
    alias_method :version, :commit_hash

    # Get a tar archive of the repo as a string
    def archive(branch_or_tag = nil)
      git 'archive', branch_or_tag || 'HEAD', binmode: true
    end

    # run a git command
    def git(*args)
      cd { run(*['git'] + args) }
    end
  end
end
