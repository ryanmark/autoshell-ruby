require 'test_helper'

class TestGit < Minitest::Test
  include Autoshell::TestHelper

  def test_clone_repo
    r = autoshell :repo

    r.clone REPO_URL

    refute r.python?, "Shouldn't have python"
    refute r.node?, "Shouldn't have node"
    assert r.ruby?, 'Should have ruby'
    assert r.git?, 'Should have git'
    assert r.exist?, 'Should exist'
    assert r.dir?, 'Should be a dir'

    refute r.environment?, 'Should not have an environment'
  end

  def test_switch_branch
    r = autoshell :repo

    r.clone REPO_URL

    # update repo
    r.update

    # checkout a branch
    r.switch 'test'

    assert r.exist?('testfile'), 'Should have a test file'

    # update bundle
    r.setup_environment
  end

  def test_archive
    skip
  end

  def test_commit_hash
    skip
  end
end
