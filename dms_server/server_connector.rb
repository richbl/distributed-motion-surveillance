#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'socket'

require_relative 'server_logging'

# -----------------------------------------------------------------------------
# tcp server used in managing the state of clients on the network
#
class ServerConnector
  # ---------------------------------------------------------------------------
  # initialize, and pass in server port and entry-point routine called by
  # the server whenever a client connects
  #
  def initialize(server_port, routine)
    @server = ServerLogging.new
    @server.logging "BEGIN #{self.class}"
    @entrypoint_routine = routine
    start_server(server_port)
  end

  # ---------------------------------------------------------------------------
  # start tcp server
  #
  def start_server(server_port)
    server = TCPServer.new server_port
    begin
      server_loop(server)
    rescue StandardError => se
      @server.logging "SERVER ERROR: #{se}", 3
    end
  end

  # ---------------------------------------------------------------------------
  # server logic that creates a new thread (fork) and makes a call
  # into the entry-point routine on each client connection
  #
  def server_loop(server)
    loop do
      Thread.start(server.accept) do |client|
        _unused, remote_port, _unused, remote_ip = client.peeraddr
        client.puts @entrypoint_routine.call
        @server.logging "connection from #{remote_ip}:#{remote_port}"
        client.close
      end
    end
  end
end
