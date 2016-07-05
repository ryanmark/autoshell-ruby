require 'test_helper'

class TestGit < Minitest::Test
  include Autoshell::TestHelper

  def test_clone_repo
    r = autoshell :repo

    # working dir is empty, so
    refute r.ruby?, "Shouldn't have ruby"
    refute r.python?, "Shouldn't have python"
    refute r.node?, "Shouldn't have node"
    refute r.git?, "Shouldn't have git"
    refute r.exist?, "Shouldn't exist"
    refute r.dir?, "Shouldn't be a dir"
    assert r.read('autotune-config.json').nil?,
           'Should not have a config file'

    r.clone REPO_URL

    refute r.python?, "Shouldn't have python"
    refute r.node?, "Shouldn't have node"
    assert r.ruby?, 'Should have ruby'
    assert r.git?, 'Should have git'
    assert r.exist?, 'Should exist'
    assert r.dir?, 'Should be a dir'

    assert r.read('autotune-config.json'), 'Should have a config file'

    refute r.environment?, 'Should not have an environment'
  end

  def test_switch_branch
    r = autoshell :repo

    r.clone REPO_URL

    # update repo
    r.update

    refute r.exist?('testfile'), 'Should have a test file'

    # checkout a branch
    r.switch 'test'

    assert r.exist?('testfile'), 'Should have a test file'

    # update bundle
    r.setup_environment
  end

  def test_checkout_hash
    updated_submod = 'e03176388c7d1f6dd91a5856b0197d80168a57a2'
    with_submod = '4d3dc6432b464f4d42b0e30b891824ad72ef6abb'
    no_submod = 'fdb4b18d01461574f68cbd763731499af2da561d'

    r = autoshell :example
    r.clone REPO_URL

    assert_equal updated_submod, r.version
    assert r.exist?('submodule/testfile'), 'Should have submodule testfile'
    assert r.exist?('submodule/test.rb'), 'Should have submodule test.rb'

    r.commit_hash_for_checkout = with_submod
    r.update
    assert_equal with_submod, r.version
    refute r.exist?('submodule/testfile'), 'Should not have submodule testfile'
    assert r.exist?('submodule/test.rb'), 'Should have submodule test.rb'

    r.commit_hash_for_checkout = no_submod
    r.update
    assert_equal no_submod, r.version
    refute r.exist?('submodule/testfile'), 'Should not have submodule testfile'
    refute r.exist?('submodule/test.rb'), 'Should not have submodule test.rb'

    r.branch = 'master'
    r.commit_hash_for_checkout = updated_submod
    r.update
    assert_equal updated_submod, r.version
    assert r.exist?('submodule/testfile'), 'Should have submodule testfile'
    assert r.exist?('submodule/test.rb'), 'Should have submodule test.rb'
  end

  def test_archive
    skip
  end

  def test_commit_hash
    skip
  end
end
