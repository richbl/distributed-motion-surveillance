#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#
require 'thread'

require_relative 'lib_config'

# ----------------------------------------------------------------------------
# audio library
#
module LibAudio
  # ----------------------------------------------------------------------------
  # self.play_audio(audio_file) uses shell aplay command (system default) to
  # play audio_file returning bool on success/failure
  #
  def self.play_audio(audio_file)
    system("#{LibConfig::APLAY} -q " + audio_file)
  end
end
