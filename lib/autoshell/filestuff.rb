require 'fileutils'
require 'mime/types'
require 'json'

module Autoshell
  module Filestuff
    # expand a local path for this working directory
    # @param path [String] local path to check
    # @return [String] absolute path
    def expand(path)
      File.expand_path(path, working_dir)
    end

    # Check if the param exists on the system
    # @param path [String] local path to check
    # @return [Boolean]
    def exist?(path = '.')
      File.exist?(expand path)
    end

    # Check if the param is a directory
    # @param path [String] local path to check
    # @return [Boolean]
    def dir?(path = '.')
      Dir.exist?(expand path)
    end

    # Get matching files
    # @param pattern [String] glob expression
    # @return [Array] list of matching files
    def glob(pattern)
      cd { Dir.glob(pattern) }
    end

    # Delete a path in the working directory
    # @param path [String] local file to delete
    def rm(path = '.')
      FileUtils.rm_rf(expand path)
    end

    # copy a path from the working directory to another location
    # @param path [string] local file to copy
    # @param dest [string] destination path to copy to
    def cp(path, dest, force: false)
      rm(dest) if force
      raise CommandError, 'Destination exists' if exist?(dest)

      mkpdir dest
      FileUtils.cp_r(expand(path), expand(dest))
    end

    # Move something from the working directory to another location
    # @param path [string] local file to move
    # @param dest [string] destination path to move to
    def mv(path, dest, force: false)
      rm(dest) if force
      raise CommandError, 'Destination exists' if exist?(dest)

      mkpdir dest
      FileUtils.mv(expand(path), expand(dest))
    end

    # Return an array of filenames
    # @param path [String] path to list
    # @return [Array<String>] all filenames in this directory
    def ls(path = '.')
      Dir.entries(expand path)
    end

    # Change directories
    # @param path [String] path to work from
    # @yieldreturn [self] this instance
    # @return result of the block
    def cd(path = nil)
      unless path.nil?
        original_dir = working_dir
        @working_dir = expand(path)
      end

      unless Dir.exist? working_dir
        raise CommandError,
              "cd: The directory '#{working_dir}' does not exist"
      end

      ret = nil
      Dir.chdir(working_dir) do
        ret = yield self
      end
      @working_dir = original_dir unless path.nil?

      ret # return
    end

    # Make all the parent directories for a path
    # @param path [String] local dir path to create
    def mkpdir(path = '.')
      mkdir(File.dirname(expand path))
      self
    end

    # Make all the directories for a path
    # @param path [String] local dir path to create
    def mkdir(path = '.')
      FileUtils.mkdir_p(expand path)
      self
    end

    # Move this working dir to another path
    # @param path [String] destination path to move to
    def move_to(path)
      mv '.', path
      self.home_dir = self.working_dir = expand path
      self
    end

    # Copy this working dir to another path
    # @param path [String] destination path to copy to
    def copy_to(path = nil, force: nil)
      return super if path.nil?

      unless Dir.exist? working_dir
        raise CommandError,
              "copy_to: The directory '#{working_dir}' does not exist"
      end

      cp '.', path, force: force
      self.class.new(expand path)
    end

    # Get mime for a file
    # @param path [String] local path of the file
    # @return [String] mime type
    def mime(path)
      MIME::Types.type_for(expand path).first
    end

    # Read and parse a file
    # @param path [String] local path of the file to read
    # @return [String] contents of file at path
    def read(path)
      m = mime(path)
      return read_text(path) unless m
      return read_json(path) if m.content_type == 'application/json'
      return read_yaml(path) if m.content_type == 'text/x-yaml'
      return read_binary(path) if m.binary?
      read_text(path)
    end

    # Read and parse JSON from a local path
    # @param path [String] local path of the file to read
    # @return contents of JSON
    def read_json(path)
      text = read_text(path)
      return nil if text.nil?
      JSON.parse(text)
    rescue JSON::ParserError
      nil
    end

    # Read and parse YAML from a local path
    # @param path [String] local path of the file to read
    # @return contents of YAML
    def read_yaml(path)
      require 'yaml'
      text = read_text(path)
      return nil if text.nil?
      YAML.parse(text).to_h
    rescue Psych::SyntaxError
      nil
    end

    # return the contents of a local path
    # @param path [String] local path of the file to read
    # @return [String] text contents of path
    def read_text(path)
      File.read(expand path) if exist? path
    end

    # return the binary contents of a local path
    # @param path [String] local path of the file to read
    # @return [String] binary contents of path
    def read_binary(path)
      File.binread(expand path) if exist? path
    end
  end
end
