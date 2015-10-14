require 'test_helper'

class TestFilestuff < Minitest::Test
  include Autoshell::TestHelper

  def test_expand
    skip
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

  def test_cp
    skip
  end

  def test_mv
    skip
  end

  def test_mkpdir
    skip
  end

  def test_move_to
    skip
  end

  def test_copy_to
    skip
  end

  def test_mime
    skip
  end

  def test_read
    skip
  end

  def test_cd
    sh = autoshell(:ruby)
    assert_equal sh.working_dir, sh.cd { sh.working_dir }
  end
end
