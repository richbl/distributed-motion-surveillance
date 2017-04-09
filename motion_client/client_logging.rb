#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require_relative '../lib/lib_log'
require_relative 'client_config'

# -----------------------------------------------------------------------------
# wrap the LibLog logging object with server-side configuration options
#
class ClientLogging
  # ---------------------------------------------------------------------------
  #
  def initialize
    create_logfile
  end

  # ---------------------------------------------------------------------------
  # create log file as defined in configuration
  #
  def create_logfile
    LibLog.create_logfile(ClientConfig::LOGGING,
                          ClientConfig::LOG_LOCATION,
                          ClientConfig::LOG_FILENAME)
  end

  # ---------------------------------------------------------------------------
  # logging wrapper to add severity levels
  #
  def logging(msg, severity = 1)
    return if ClientConfig::LOGGING.zero?
    LibLog.log(msg, severity)
  end
end
