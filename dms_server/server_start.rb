#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require_relative 'server_connector'
require_relative 'server_manager'
require_relative 'server_config'

dms_server = ServerManager.new
ServerConnector.new(ServerConfig::SERVER_PORT,
                    dms_server.method(:determine_motion_state))
