#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

module ServerConfig
  # ---------------------------------------------------------------------------
  # enable (1) or disable (0) application logging
  #
  # NOTE: passing in 2 sets logging to STDOUT
  #
  LOGGING = 2

  # ---------------------------------------------------------------------------
  # logging filename
  #
  # ignored if LOGGING == 0
  #
  LOG_FILENAME = 'motion_server.log'.freeze

  # ---------------------------------------------------------------------------
  # location of logfile (full path)
  #
  # by default, this is in the local folder (e.g.,
  # /etc/motion_surveillance/motion_monitor)
  #
  # ignored if LOGGING == 0
  #
  LOG_LOCATION = File.expand_path(File.dirname(__FILE__))

  # ---------------------------------------------------------------------------
  # enable (1) or disable (0) the play-back of audio on motion daemon
  # start/stop
  #
  PLAY_AUDIO = 1

  # ---------------------------------------------------------------------------
  # port on which to run the motion server
  #
  SERVER_PORT = 1965

  # ---------------------------------------------------------------------------
  # this audio file played when the motion daemon is activated
  #
  # by default, this is in the local folder (e.g.,
  # /etc/motion_surveillance/motion_monitor)
  #
  # ignored if PLAY_AUDIO == 0
  #
  AUDIO_MOTION_START = File.expand_path(File.dirname(__FILE__)) +
                       '/media/motion_start.wav'

  # ---------------------------------------------------------------------------
  # this audio file played when the motion daemon is deactivated
  #
  # by default, this is in the local folder (e.g.,
  # /etc/motion_surveillance/motion_monitor)
  #
  # ignored if PLAY_AUDIO == 0
  #
  AUDIO_MOTION_STOP = File.expand_path(File.dirname(__FILE__)) +
                      '/media/motion_stop.wav'

  # ---------------------------------------------------------------------------
  # enable (1) or disable (0) motion daemon based on time-of-day
  #
  SCAN_FOR_TIME = 0

  # ---------------------------------------------------------------------------
  # start and end times (24-hour format) for motion to always be enabled
  #
  # ignored if SCAN_FOR_TIME == 0
  #
  ALWAYS_ON_START_TIME = '2300'.freeze
  ALWAYS_ON_END_TIME = '0400'.freeze

  # ---------------------------------------------------------------------------
  # network configuration variables that characterize the LAN where devices
  # will be scanned for to determine when motion should be run
  #
  # where:
  #
  #   IP_BASE = first three address octets defining the LAN (e.g., 192.168.1.)
  #   IP_RANGE = fourth address octet defined as a range (e.g., 1..254)
  #
  IP_BASE = '10.10.10.'.freeze
  IP_RANGE = 100..254

  # ---------------------------------------------------------------------------
  # MAC addresses of device(s) to search for on the LAN
  #
  # NOTE: the assumption is that these devices are on the LAN, else they won't
  # be detected when ping'd
  #
  MACS_TO_FIND = ['24:da:9b:0d:53:8f', 'f8:cf:c5:d2:bb:9e'].freeze
  # MACS_TO_FIND = ['e8:cf:c5:d2:bb:9e'].freeze
end
