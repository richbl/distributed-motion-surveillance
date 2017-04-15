#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'socket'

require_relative 'client_config'
require_relative 'client_logging'

# -----------------------------------------------------------------------------
# client-side connector used for receiving messages from the server
#
class ClientConnector
  # ---------------------------------------------------------------------------
  # initialize, and pass in server socket (ip:port) and entry-point routine
  # called by the client on receipt of of server messages
  #
  def initialize(server_ip, server_port, routine)
    @client = ClientLogging.new
    @client.logging "BEGIN #{self.class}"
    @entrypoint_routine = routine
    start_client(server_ip, server_port)
  end

  # ---------------------------------------------------------------------------
  # start client-side poll
  #
  def start_client(server_ip, server_port)
    loop do
      begin
        client_loop(TCPSocket.new(server_ip, server_port))
      rescue StandardError => se
        p "client error: #{se}"
        @client.logging "CLIENT ERROR: #{se}", 3
      end
      sleep ClientConfig::CHECK_INTERVAL
    end
  end

  # ---------------------------------------------------------------------------
  # client logic that makes a call into entry-point routine on receipt of a
  # message passed by the server
  #
  def client_loop(socket)
    while (line = socket.gets)
      case msg = line.chop

      # on receipt of either 'enable' or 'disable,' call entry-point routine
      # for additional client-specific processing
      #
      when 'enable', 'disable' then @entrypoint_routine.call(msg)
      else
        @client.logging "ignoring unexpected server response: #{msg}", 2
      end
    end
  end
end
