#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'test/unit'

require_relative '../lib_config'
require_relative '../lib_motion'

# ----------------------------------------------------------------------------
# test motion library
#
class TestLibMotion < Test::Unit::TestCase
  def test_lib_motion_calls
    assert_equal LibMotion.confirm_motion_install?, true
    assert_equal LibMotion.running_motion?, false
    assert_equal LibMotion.determine_motion_pid, 0
  end

  def test_lib_motion_daemon
    assert_equal LibMotion.motion_daemon?('start'), true
    sleep 2 # delay to start motion daemon
    assert_equal LibMotion.motion_daemon?('stop'), true
  end
end
