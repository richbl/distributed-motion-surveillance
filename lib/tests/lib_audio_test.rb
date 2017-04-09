#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'test/unit'

require_relative '../lib_audio'
require_relative '../lib_log'
require_relative '../../motion_server/server_config'

# ----------------------------------------------------------------------------
# test audio library
#
class TestLibAudio < Test::Unit::TestCase
  def test_lib_audio
    assert_equal LibAudio.play_audio(ServerConfig::AUDIO_MOTION_START),
                 true
    assert_equal LibAudio.play_audio(ServerConfig::AUDIO_MOTION_STOP),
                 true
  end
end
