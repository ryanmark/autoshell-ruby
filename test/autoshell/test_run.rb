require 'test_helper'

class TestIntegration < Minitest::Test
  include Autoshell::TestHelper

  def test_process
    r = autoshell :process

    Thread.new do
      sleep 4
      # `killall stress-ng`
      `killall -9 sleep`
    end

    assert_raises Autoshell::CommandError do
      r.cd do
        puts r.run('./autotune-run-test.sh')
      end
    end
  end
end
