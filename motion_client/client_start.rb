#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require_relative 'client_connector'
require_relative 'client_manager'
require_relative 'client_config'

motion_client = ClientManager.new
ClientConnector.new(ClientConfig::SERVER_IP, ClientConfig::SERVER_PORT,
                    motion_client.method(:process_motion_state))
