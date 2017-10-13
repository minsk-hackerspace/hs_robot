require 'sinatra'
require 'haml'
require_relative 'robot'

set :bind, '0.0.0.0'

get '/' do
  haml :index, layout: :main
  @robot ||= Robot.init
end

get '/answer' do
  @robot ||= Robot.new
  command = params[:keys]
  case command.to_i
    when 70
      @robot.light_switch
    when 83
      @robot.forward
      # sleep 0.06
      # @robot.stop
    when 87
      @robot.backward
      # sleep 0.1
      # @robot.stop
    when 68
      @robot.right
      # sleep 0.01
      # @robot.stop
    when 65
      @robot.left
      # sleep 0.01
      # @robot.stop
    when 32
      @robot.stop
  end
  params[:keys]
end

get '/destroy' do
  @robot = Robot.new
  @robot.stop
  @robot.stand_by
end
