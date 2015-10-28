module Autoshell
  # Stuff for working with a development environment
  module Environment
    # Is this a ruby project?
    # @return [Boolean] true if this dir has a Gemfile
    def ruby?
      exist? 'Gemfile'
    end

    # Is this a python project?
    # @return [Boolean] true if this dir has a requirements.txt
    def python?
      exist? 'requirements.txt'
    end

    # Is this a node project?
    # @return [Boolean] true if this dir has a package.json
    def node?
      exist? 'package.json'
    end

    # Setup the environment
    # @return [String] output of the environment setup commands
    def setup_environment
      setup_ruby_environment ||
        setup_python_environment ||
        setup_node_environment
    end

    # Do we have an environment setup?
    # @return [Boolean] true if this dir has a bundle, virtualenv
    #                   or node modules
    def environment?
      dir?('.bundle') || dir?('.virtualenv') || dir?('node_modules')
    end

    # Setup a ruby environment
    # @return [String] output of the environment setup commands
    def setup_ruby_environment
      return unless ruby?
      cd { run 'bundle', 'install', '--path', '.bundle', '--deployment' }
    end

    # Setup a python environment
    # @return [String] output of the environment setup commands
    def setup_python_environment
      return unless python?
      cd do
        [
          run('virtualenv', '.virtualenv'),
          run('./.virtualenv/bin/pip', '-r', 'requirements.txt')
        ].join("\n")
      end
    end

    # Setup a node environment
    # @return [String] output of the environment setup commands
    def setup_node_environment
      return unless node?
      cd { run 'npm', 'install' }
    end
  end
end
