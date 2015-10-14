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

    d.cd do
      d.run('./autotune-build', stdin_data: { foo: 'bar' })
    end

    # checkout a different branch in the repo
    d.switch 'test'

    # what happens if i add random crap and switch?
    open(d.expand('foo.bar'), 'w') do |fp|
      fp.write 'baz!!!!'
    end
    open(d.expand('testfile'), 'w') do |fp|
      fp.write 'baz!!!!'
    end

    # random crap should get disappeard
    d.switch 'master'
    assert !d.exist?('foo.bar'), 'Random crap should be gone'
  end
end
