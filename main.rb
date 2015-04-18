require 'sinatra'
require 'socket'
require 'haml'

require_relative 'robot/robot'
require_relative 'robot/gpio'
require_relative 'robot/pin'

class HS_Robot < Sinatra::Application
  get '/init' do
    @robot ||= Robot.new
  end

  get '/' do
    haml :index, layout: :main
  end

  get '/answer' do
    command = 's'
    case params[:keys].to_i
      when 83
        command = 's'
        @robot.forward
      when 87
        command = 'w'
        @robot.backward
      when 68
        command = 'd'
        @robot.right
      when 65
        command = 'a'
        @robot.left
      when 32
        command = ' '
        @robot.stop
    end

    command
  end

  get '/destroy' do
    @robot.destroy
  end

end