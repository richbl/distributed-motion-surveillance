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
    assert_equal File.file?(LibConfig::GEM), true
    assert_equal File.file?(LibConfig::GREP), true
    assert_equal File.file?(LibConfig::KILL), true
    assert_equal File.file?(LibConfig::PING), true
    assert_equal File.file?(LibConfig::MOTION), true
  end

  def test_ruby_gems
    #
    # these GEMS are required for proper operation
    #
    assert_equal system("#{LibConfig::GEM} list -i mail > /dev/null 2>&1"), true
    assert_equal system("#{LibConfig::GEM} list -i thread > /dev/null 2>&1"),
                 true
  end
end
