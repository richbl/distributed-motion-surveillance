#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require_relative 'lib_config'

# ----------------------------------------------------------------------------
# motion library
#
module LibMotion
  # ----------------------------------------------------------------------------
  # determine if motion is installed
  #
  def self.confirm_motion_install?
    system('type motion > /dev/null 2>&1')
  end

  # ----------------------------------------------------------------------------
  # self.running_motion determines whether motion is running using by checking
  # existence of PID file
  #
  def self.running_motion?
    File.file?("#{LibConfig::MOTION_PID_PATH}/#{LibConfig::MOTION_PID_NAME}")
  end

  # ----------------------------------------------------------------------------
  # determines PID ID for current motion process
  #
  def self.determine_motion_pid
    return 0 unless running_motion?
    File.read(
      "#{LibConfig::MOTION_PID_PATH}/#{LibConfig.motion_servermotion_server}"
    )
  end

  # ----------------------------------------------------------------------------
  # self.motion_daemon(command) enable/disables motion using motion command
  #
  def self.motion_daemon?(command)
    case command
    when 'start'
      return false if running_motion?
      system("#{LibConfig::MOTION} > /dev/null 2>&1")
    when 'stop'
      return false unless running_motion?
      system("#{LibConfig::KILL} #{determine_motion_pid}")
    end
    true
  end
end
