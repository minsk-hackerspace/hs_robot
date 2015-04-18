require 'sinatra'
require 'sinatra/reloader' if development?
require 'socket'
require 'haml'
require 'serialport'

port_str = "/dev/cu.usbmodem1421"  #may be different for you
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

get '/' do
  haml :index, layout: :main
end

get '/answer' do
  TCPSocket.open("localhost", 2000) {|s|
    s.send params[:keys], 0
    p s.read
    command = 's'
    case params[:keys].to_i
      when 83
        command = 's'
      when 87
        command = 'w'
      when 68
        command = 'd'
      when 65
        command = 'a'
      when 32
        command = ' '
    end
    sp.write(command +"\r\n")
    command
  }
end