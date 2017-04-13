#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require_relative '../lib/lib_config'
require_relative '../lib/lib_motion'
require_relative '../lib/lib_network'
require_relative '../lib/lib_audio'
require_relative 'server_config'
require_relative 'server_logging'

# -----------------------------------------------------------------------------
# server-side methods to determine enable/disable state of the motion daemon
#
class ServerManager
  # ---------------------------------------------------------------------------
  # initialize, set @motion_state which determines state of motion daemon for
  # all network device clients
  #
  def initialize
    @motion_state = 'disable'
    @server = ServerLogging.new
    @server.logging "BEGIN #{self.class}"
  end

  # ---------------------------------------------------------------------------
  # determine whether to start motion based device presence/time logic
  # note: the return of this method is pushed to clients at the server
  #
  def determine_motion_state
    @server.logging 'checking motion state'

    if time_in_range? || !device_on_lan?
      enable_motion_daemon
    else
      disable_motion_daemon
    end
  end

  # ---------------------------------------------------------------------------
  #
  def enable_motion_daemon
    return @motion_state unless @motion_state == 'disable'

    @server.logging 'motion_state set to ENABLE'
    LibAudio.play_audio(ServerConfig::AUDIO_MOTION_START) if
    ServerConfig::PLAY_AUDIO == 1
    @motion_state = 'enable'
  end

  # ---------------------------------------------------------------------------
  #
  def disable_motion_daemon
    return @motion_state unless @motion_state == 'enable'

    @server.logging 'motion_state set to DISABLE'
    LibAudio.play_audio(ServerConfig::AUDIO_MOTION_STOP) if
    ServerConfig::PLAY_AUDIO == 1
    @motion_state = 'disable'
  end

  # ---------------------------------------------------------------------------
  # checks to see if the configured time range crosses into the next day, and
  # determines time range accordingly
  #
  def calc_date_range?
    cur_time = Time.new.strftime('%H%M')
    if ServerConfig::ALWAYS_ON_START_TIME > ServerConfig::ALWAYS_ON_END_TIME
      cur_time >= ServerConfig::ALWAYS_ON_START_TIME ||
        cur_time < ServerConfig::ALWAYS_ON_END_TIME
    else
      cur_time >= ServerConfig::ALWAYS_ON_START_TIME &&
        cur_time < ServerConfig::ALWAYS_ON_END_TIME
    end
  end

  # ---------------------------------------------------------------------------
  # checks to see if the current time is within the bounds of the 'always on'
  # range (if that option is enabled)
  #
  def time_in_range?
    return false if ServerConfig::SCAN_FOR_TIME.zero?

    @server.logging 'scan for time in range'
    calc_date_range?
  end

  # ---------------------------------------------------------------------------
  # checks to see if device mac exists on LAN
  #
  def device_on_lan?
    # freshen local arp cache to guarantee good results when searching for
    # devices by MAC address
    LibNetwork.ping_hosts(ServerConfig::IP_BASE, ServerConfig::IP_RANGE)

    @server.logging 'look for device(s) on LAN'
    LibNetwork.find_macs?(ServerConfig::MACS_TO_FIND)
  end
end
