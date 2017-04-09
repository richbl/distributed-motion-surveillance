#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'test/unit'
require 'logger'

require_relative '../lib_log'

# ----------------------------------------------------------------------------
# test configuration library
#
class TestLibLog < Test::Unit::TestCase
  def test_lib_log
    curdir = File.expand_path(File.dirname(__FILE__))
    LibLog.create_logfile(1, curdir, 'test_lib.log')
    if File.exist?(curdir + '/test_lib.log')
      File.delete(curdir + '/test_lib.log')
    end
    assert_not_nil LibLog.logger
  end
end
