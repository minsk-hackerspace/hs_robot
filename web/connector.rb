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
    when 70
      @robot.light_switch
    when 83
      @robot.forward
      sleep 0.5
      @robot.stop
    when 87
      @robot.backward
      sleep 0.5
      @robot.stop
    when 68
      @robot.right
      sleep 0.15
      @robot.stop
    when 65
      @robot.left
      sleep 0.15
      @robot.stop
    when 32
      @robot.stop
  end
  client.close
end


