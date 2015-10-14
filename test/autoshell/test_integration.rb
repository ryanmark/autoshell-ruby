require 'test_helper'

class TestIntegration < Minitest::Test
  include Autoshell::TestHelper

  def test_that_it_has_a_version_number
    refute_nil Autoshell::VERSION
  end

  def test_basic_workflow
    r = autoshell :repo
    d = autoshell :destination

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

    d.working_dir do
      d.run('./autotune-build', stdin_data: { foo: 'bar' })
    end

    # checkout a different branch in the repo
    d.switch 'test'
    assert d.exist?('testfile'), 'Should have a test file'

    # what happens if i add random crap and switch?
    open(d.expand('foo.bar'), 'w') do |fp|
      fp.write 'baz!!!!'
    end
    assert d.exist?('foo.bar'), 'Should have random crap'

    open(d.expand('testfile'), 'w') do |fp|
      fp.write 'baz!!!!'
    end

    # random crap should get disappeard
    d.switch 'master'
    assert !d.exist?('foo.bar'), 'Random crap should be gone'
  end
end
