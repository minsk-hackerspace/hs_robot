require 'socket'

require_relative 'robot/robot'
require_relative 'robot/gpio'
require_relative 'robot/pin'

@robot ||= Robot.new

server = TCPServer.new 2000 # Server bound to port 2000
p 'Server started'

loop do
  client = server.accept # Wait for a client to connect
  command = client.recv(10)
  p [command, 'received']
  case command.to_i
    when 102
	  @robot.light_switch
    when 83
      @robot.forward
    when 87
      @robot.backward
    when 68
      @robot.right
    when 65
      @robot.left
    when 32
      @robot.stop
  end
  client.close
end


