#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

module ClientConfig
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
  LOG_FILENAME = 'motion_client.log'.freeze

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
  # ip, port on which to run the motion server
  #
  SERVER_IP = 'localhost'.freeze
  SERVER_PORT = 1965

  # ---------------------------------------------------------------------------
  # interval (in seconds) for client to check server for motion state
  #
  CHECK_INTERVAL = 15
end
