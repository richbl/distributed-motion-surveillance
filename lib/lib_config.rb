#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

# ----------------------------------------------------------------------------
# configuration library for system commands/services
#
module LibConfig
  APLAY = '/usr/bin/aplay'.freeze
  ARP = '/usr/sbin/arp'.freeze
  GREP = '/bin/grep'.freeze
  KILL = '/bin/kill'.freeze
  PING = '/bin/ping'.freeze
  PS = '/bin/ps'.freeze
  MOTION = '/usr/bin/motion'.freeze
  MOTION_PID_PATH = '/var/run/motion'.freeze
  MOTION_PID_NAME = 'motion.pid'.freeze
end
