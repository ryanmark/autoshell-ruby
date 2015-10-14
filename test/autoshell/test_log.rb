require 'test_helper'

class TestLog < Minitest::Test
  include Autoshell::TestHelper

  def test_log_output
    sh = autoshell(:test)

    # Do some commands
    output = sh.run 'ls'

    assert sh.log_output =~ /#{output}$/
  end

  def test_log_reset
    sh = autoshell(:test)

    # Do some commands
    output = sh.run 'ls'

    assert sh.log_output =~ /#{output}$/
    sh.log_reset

    assert sh.log_output.empty?
  end

  def test_custom_log
    skip
  end

  def test_log_color
    skip
  end
end
