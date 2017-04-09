#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'socket'

require_relative 'client_config'
require_relative 'client_logging'

# -----------------------------------------------------------------------------
# client-side connector used for receiving motion state from the server
#
class ClientConnector
  # ---------------------------------------------------------------------------
  # initialize, and pass in server socket (ip:port) and entrypoint routine for
  # determining motion program state for network device clients
  #
  def initialize(server_ip, server_port, routine)
    @client = ClientLogging.new
    @client.logging "BEGIN #{self.class}"
    start_client(server_ip, server_port, routine)
  end

  # ---------------------------------------------------------------------------
  # start client-side poll
  #
  def start_client(server_ip, server_port, routine)
    loop do
      begin
        client_loop(TCPSocket.new(server_ip, server_port), routine)
      rescue StandardError => se
        p "client error: #{se}"
        @client.logging "CLIENT ERROR: #{se}", 3
      end
      sleep ClientConfig::CHECK_INTERVAL
    end
  end

  # ---------------------------------------------------------------------------
  # client logic that makes a call into routine to determine motion
  # daemon state (starting or stopping the motion daemon)
  #
  def client_loop(socket, routine)
    while (line = socket.gets)
      case msg = line.chop
      when 'enable', 'disable' then routine.call(msg)
      else
        @client.logging "ignoring unexpected server response: #{msg}", 2
      end
    end
  end
end
