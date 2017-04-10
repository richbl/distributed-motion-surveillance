#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'test/unit'
require 'logger'

require_relative '../lib_log'
require_relative '../lib_config'

# ----------------------------------------------------------------------------
# test configuration library
#
class TestLibConfig < Test::Unit::TestCase
  def test_lib_config_files
    assert_equal File.file?(LibConfig::APLAY), true
    assert_equal File.file?(LibConfig::ARP), true
    assert_equal File.file?(LibConfig::GREP), true
    assert_equal File.file?(LibConfig::KILL), true
    assert_equal File.file?(LibConfig::PING), true
    assert_equal File.file?(LibConfig::MOTION), true
  end

  def test_lib_config_folders
    #
    # NOTE: for this test to pass, motion must have first been run in the
    # current session, else MOTION_PID_PATH has not yet been created
    #
    assert_equal File.directory?(LibConfig::MOTION_PID_PATH), true
  end
end
