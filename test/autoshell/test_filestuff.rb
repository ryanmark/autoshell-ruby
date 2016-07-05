require 'test_helper'

class TestFilestuff < Minitest::Test
  include Autoshell::TestHelper

  def test_expand
    d = autoshell :empty

    assert_equal File.join(d.to_s, 'foo'), d.expand('foo')
  end

  def test_exist
    d = autoshell :empty
    refute d.exist?
    assert d.exist? '/bin'

    d = autoshell :ruby
    assert d.exist?
    assert d.exist? 'Gemfile'
  end

  def test_dir
    d = autoshell :empty
    refute d.dir?
    assert d.dir? '/bin'

    d = autoshell :ruby
    assert d.dir?
    refute d.dir? 'Gemfile'
  end

  def test_glob
    skip
  end

  def test_rm
    skip
  end

  def test_mv
    skip
  end

  def test_mkpdir
    r = autoshell :repo
    r.mkpdir

    assert File.exist?(File.dirname(r.working_dir)),
           'Parent dir should exist'
    refute r.exist?,
           'Child dir should not exist'
  end

  def test_move_to
    skip
  end

  def test_copy_to
    r = autoshell :repo
    d = autoshell :destination

    # Make sure we can't copy a nonexistant dir
    assert_raises Autoshell::CommandError do
      r.copy_to d.working_dir
    end

    r.clone REPO_URL
    r.setup_environment

    # create a snapshot!
    r.copy_to d.working_dir

    # now should have stuff
    assert d.ruby?, 'Should have ruby'
    refute d.python?, "Shouldn't have python"
    refute d.node?, "Shouldn't have node"
    assert d.git?, 'Should have git'
    assert d.exist?, 'Should exist'
    assert d.dir?, 'Should be a dir'
    assert d.environment?, 'Should have environment'

    assert r.exist?('autotune-build'), 'Should have build script'

    # make sure we can't copy a snapshot twice
    assert_raises Autoshell::CommandError do
      r.copy_to d.working_dir
    end
  end

  def test_mime
    skip
  end

  def test_read
    d = autoshell :ruby

    # what happens if i add random crap and switch?
    open(d.expand('foo.bar'), 'w') do |fp|
      fp.write 'baz!!!!'
    end
    assert d.exist?('foo.bar'), 'Should have random crap'

    assert 'baz!!!!', d.read('foo.bar')

    open(d.expand('testfile'), 'w') do |fp|
      fp.write 'baz!!!!'
    end
    assert 'baz!!!!', d.read('testfile')
  end

  def test_cd
    sh = autoshell(:ruby)
    assert_equal sh.working_dir, sh.cd { sh.working_dir }
  end
end
