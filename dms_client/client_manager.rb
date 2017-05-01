#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require_relative '../lib/lib_motion'
require_relative '../lib/lib_network'
require_relative '../lib/lib_audio'

require_relative 'client_config'
require_relative 'client_logging'

# -----------------------------------------------------------------------------
# client-side methods to enable/disable the motion daemon
#
class ClientManager
  # ---------------------------------------------------------------------------
  # start logging and confirm that the motion program is installed
  #
  def initialize
    @client = ClientLogging.new
    @client.logging "BEGIN #{self.class}"
    confirm_motion_install
  end

  # ---------------------------------------------------------------------------
  # confirm that the motion program is installed/configured
  #
  def confirm_motion_install
    return if LibMotion.confirm_motion_install?

    @client.logging 'IMPROPER MOTION CONFIGURATION DETECTED: EXITING', 3
    exit
  end

  # ---------------------------------------------------------------------------
  # process motion_state received from server push
  #
  def process_motion_state(motion_state)
    @client.logging "motion_state received from server is: #{motion_state}"
    case motion_state
    when 'enable' then start_motion_daemon
    when 'disable' then stop_motion_daemon
    end
  end

  # ---------------------------------------------------------------------------
  # start motion daemon
  #
  def start_motion_daemon
    @client.logging 'motion started' if LibMotion.motion_daemon?('start')
  end

  # ---------------------------------------------------------------------------
  # stop motion daemon
  #
  def stop_motion_daemon
    @client.logging 'motion stopped' if LibMotion.motion_daemon?('stop')
  end
end
