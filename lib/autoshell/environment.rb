module Autoshell
  module Environment
    # Is this a ruby project?
    def ruby?
      exist? 'Gemfile'
    end

    # Is this a python project?
    def python?
      exist? 'requirements.txt'
    end

    # Is this a node project?
    def node?
      exist? 'package.json'
    end

    # Setup the environment
    def setup_environment
      setup_ruby_environment || setup_python_environment || setup_node_environment
    end

    # Do we have an environment setup?
    def environment?
      dir?('.bundle') || dir?('.virtualenv') || dir?('node_modules')
    end

    # Setup a ruby environment
    def setup_ruby_environment
      return unless ruby?
      cd { run 'bundle', 'install', '--path', '.bundle', '--deployment' }
    end

    # Setup a python environment
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
    def setup_node_environment
      return unless node?
      cd { run 'npm', 'install' }
    end
  end
end
