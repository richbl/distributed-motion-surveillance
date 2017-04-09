#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'socket'

require_relative 'server_logging'

# -----------------------------------------------------------------------------
# tcp server used in managing the state of motion clients on the network
#
class ServerConnector
  # ---------------------------------------------------------------------------
  # initialize, and pass in port and entrypoint routine for determining motion
  # program state of network device clients
  #
  def initialize(server_port, routine)
    @server = ServerLogging.new
    @server.logging "BEGIN #{self.class}"
    start_server(server_port, routine)
  end

  # ---------------------------------------------------------------------------
  # start tcp server
  #
  def start_server(server_port, routine)
    server = TCPServer.new server_port
    begin
      server_loop(server, routine)
    rescue StandardError => se
      @server.logging "SERVER ERROR: #{se}", 3
    end
  end

  # ---------------------------------------------------------------------------
  # server logic that creates a new thread (fork) for each client device and
  # makes a call into entrypoint routine to determine motion program state
  #
  def server_loop(server, routine)
    while (client = server.accept)
      fork do
        _unused, remote_port, _unused, remote_ip = client.peeraddr
        client.puts routine.call
        @server.logging "connection from #{remote_ip}:#{remote_port}"
        client.close
      end
      client.close
    end
  end
end
