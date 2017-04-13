#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

module DMSMailConfig
  # ---------------------------------------------------------------------------
  # enable (1) or disable (0) application logging
  #
  # NOTE: passing in 2 sets logging to STDOUT (used when running as daemon)
  #
  LOGGING = 2

  # ----------------------------------------------------------------------------
  # logging filename
  #
  # ignored if LOGGING == 0
  #
  LOG_FILENAME = 'dms_mail.log'.freeze

  # ----------------------------------------------------------------------------
  # location of logfile (full path)
  # by default, this is in the dms_mail folder (e.g.,
  # /etc/distributed_motion_surveillance/dms_mail)
  #
  # ignored if LOGGING == 0
  #
  LOG_LOCATION = File.expand_path(File.dirname(__FILE__)).freeze

  # ----------------------------------------------------------------------------
  # email sender
  #
  EMAIL_FROM = 'motion@businesslearninginc.com'.freeze

  # ----------------------------------------------------------------------------
  # email recipient
  #
  EMAIL_TO = 'user@gmail.com'.freeze

  # ----------------------------------------------------------------------------
  # email body
  #
  # NOTE that reserved words use the syntax !ALLCAPS and are replaced in the
  # application
  #
  EMAIL_BODY = 'Motion detected an event of importance. The event (#!EVENT) '\
  'shows !PIXELS pixels changed, and was captured by Camera #!CAMERA.'.freeze

  # ----------------------------------------------------------------------------
  # mail (smtp) configuration details
  #
  # NOTE that these default values are typical of a standard gmail.com account
  # configuration
  #
  SMTP_ADDRESS = 'smtp.gmail.com'.freeze
  SMTP_PORT = '587'.freeze
  SMTP_DOMAIN = 'localhost'.freeze
  SMTP_USERNAME = 'user'.freeze
  SMTP_PASSWORD = 'password'.freeze
  SMTP_AUTHENTICATION = 'plain'.freeze
  SMTP_ENABLE_STARTTLS_AUTO = 'true'.freeze
end
