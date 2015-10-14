require 'autoshell'
require 'fileutils'

module Autoshell
  # Helper test class
  module TestHelper
    REPO_URL = 'https://github.com/voxmedia/autotune-example-blueprint.git'
    FIXTURES_PATH = File.expand_path('../../../test/fixtures', __FILE__)

    def before_setup
      @dirs = {}
      @fixtures = {}
    end

    def after_teardown
      @dirs.values.each do |dir|
        FileUtils.rm_rf(dir) if File.exist?(dir)
      end
    end

    # Get a temp dir that will get cleaned-up after this test
    # @param name [Symbol] name name of the tmpdir to get
    # @return [Pathname] absolute path
    def dir(name = :test)
      @dirs[name.to_sym] ||= Pathname.new(
        File.expand_path("#{Dir.tmpdir}/#{Time.now.to_i}#{rand(1000)}/"))
    end

    # autoshell fixture retriever
    #
    # @param name [Symbol] name of the fixture to retrieve
    # @return [Autoshell::Base]
    def autoshell(name)
      @fixtures[name.to_sym] ||= begin
        tmpdir = dir(name)
        dest_path = tmpdir.join(name.to_s)

        # if there is a matching dir in fixtures, copy it to the temp dir
        fixtures_path = File.join(FIXTURES_PATH, name.to_s)
        if Dir.exist? fixtures_path
          FileUtils.mkdir_p(tmpdir)
          FileUtils.cp_r(fixtures_path, dest_path)
        end

        Autoshell.new(dest_path)
      end
    end
  end
end
