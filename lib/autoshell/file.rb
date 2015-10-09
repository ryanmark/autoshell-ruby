require 'fileutils'
require 'mime/types'
require 'json'

module Autoshell
  module File
    # Get the path for or chdir into this repo
    def working_dir(&block)
      return Dir.chdir(@working_dir, &block) if block_given?
      @working_dir
    end

    # expand a local path for this working directory
    def expand(path)
      File.expand_path(path, working_dir).to_s
    end

    def exist?(path = '.')
      File.exist?(expand path)
    end

    def dir?(path = '.')
      Dir.exist?(expand path)
    end

    def glob(pattern)
      working_dir do
        Dir.glob(pattern)
      end
    end

    # Delete a path in the working directory
    def rm(path)
      FileUtils.rm_rf(expand path)
    end

    # Copy a path from the working directory to another location
    def cp(path, dest)
      FileUtils.rm_rf(expand dest)
      if File.directory?(expand path)
        FileUtils.mkdir_p(expand dest)
        FileUtils.cp_r(expand(path), expand(dest))
      else
        FileUtils.mkdir_p(File.dirname(expand dest))
        FileUtils.cp(expand(path), expand(dest))
      end
    end

    # Return an array of filenames
    def ls
      Dir.entries(@working_dir)
    end

    # Move this working dir to another path
    def move_to(path)
      raise CommandError, 'Destination exists' if File.exist?(expand path)
      FileUtils.mkdir_p(File.dirname(expand path))
      FileUtils.mv(@working_dir, expand(path))
    end

    # Copy this working dir to another path
    def copy_to(path)
      raise CommandError, 'Destination exists' if File.exist?(expand path)
      FileUtils.mkdir_p(File.dirname(expand path))
      FileUtils.cp_r(@working_dir, expand(path))
    end

    # Delete the working directory
    def destroy
      FileUtils.rm_rf(@working_dir)
    end

    # Get mime for a file
    def mime(path)
      MIME::Types.type_for(expand path).first
    end

    # Read and parse a file
    def read(path)
      m = mime(path)
      return read_json(path) if m.content_type == 'application/json'
      return read_binary(path) if m.binary?
      read_text(path)
    end

    # read and parse json from a local path
    def read_json(path)
      text = read_text(path)
      return nil if text.nil?
      JSON.parse(text)
    rescue JSON::ParserError
      nil
    end

    # return the contents of a local path
    def read_text(path)
      File.read(expand path) if exist? path
    end

    # return the binary contents of a local path
    def read_binary(path)
      File.binread(expand path) if exist? path
    end
  end
end
