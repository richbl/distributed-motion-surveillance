#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'test/unit'

require_relative '../lib_network'

# ----------------------------------------------------------------------------
# test motion library
#
class TestLibNetwork < Test::Unit::TestCase
  def test_lib_network
    assert_equal LibNetwork.find_macs?(['00:00:00:00:00:00']), false
    assert_equal LibNetwork.ping_hosts('192.168.1', 0..100), nil
  end
end
