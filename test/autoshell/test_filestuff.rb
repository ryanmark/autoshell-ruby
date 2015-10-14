require 'test_helper'

class TestFilestuff < Minitest::Test
  include Autoshell::TestHelper

  def test_expand
    skip
  end

  def test_exist
    skip
  end

  def test_dir
    skip
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

  def test_cd
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
