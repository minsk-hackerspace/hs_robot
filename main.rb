require 'sinatra'
require 'socket'
require 'haml'

get '/' do
  haml :index, layout: :main
end

get '/answer' do
  s = TCPSocket.new 'localhost', 2000
  s.send(params[:keys], 0)
  s.close

  params[:keys]
end

get '/destroy' do
  @robot.destroy
end
