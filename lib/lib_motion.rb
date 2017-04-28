#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require_relative 'lib_config'
require 'open3'

# ----------------------------------------------------------------------------
# motion library
#
module LibMotion
  # ----------------------------------------------------------------------------
  # confirm that motion is installed
  #
  def self.confirm_motion_install?
    system('type motion > /dev/null 2>&1')
  end

  # ----------------------------------------------------------------------------
  # determines whether motion is running, returning PID
  #
  def self.running_motion
    Open3.popen3('pgrep motion') do |_stdin, stdout, _stderr, _wait_thr|
      stdout.read.to_i
    end
  end

  # ----------------------------------------------------------------------------
  # enable/disables motion daemon
  #
  def self.motion_daemon?(command)
    case command
    when 'start'
      return false if running_motion > 0
      system("#{LibConfig::MOTION} > /dev/null 2>&1")
    when 'stop'
      return false unless (motion_pid = running_motion) > 0
      Process.kill('KILL', motion_pid)
    end
    true
  end
end
