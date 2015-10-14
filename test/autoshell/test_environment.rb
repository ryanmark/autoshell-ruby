require 'test_helper'

class TestEnvironment < Minitest::Test
  include Autoshell::TestHelper

  def test_empty_dir
    r = autoshell :empty

    # working dir is empty, so
    refute r.ruby?, "Shouldn't have ruby"
    refute r.python?, "Shouldn't have python"
    refute r.node?, "Shouldn't have node"
    refute r.git?, "Shouldn't have git"
    refute r.exist?, "Shouldn't exist"
    refute r.dir?, "Shouldn't be a dir"
  end

  def test_ruby
    sh = autoshell(:ruby)
    assert sh.ruby?
    refute sh.environment?
  end

  def test_setup_ruby_environment
    r = autoshell :ruby

    r.setup_environment

    assert r.environment?, 'Should have an environment'

    # update the bundle
    FileUtils.rm_rf(r.expand '.bundle')
    assert !r.environment?, 'Should not have an environment'

    r.setup_environment
    assert r.environment?, 'Should have environment'
  end

  def test_setup_python_environment
    skip
  end

  def test_setup_node_environment
    skip
  end
end
