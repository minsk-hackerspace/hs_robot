#!/bin/sh

WEB_HOME=/home/pi/hs_robot/web


restart_sinatra () {

	ruby $WEB_HOME/connector.rb &

	CONNECTOR_PID=$!

	ruby $WEB_HOME/main.rb -o 0.0.0.0 -p 8081 &

	MAIN_PID=$!

}


restart_sinatra


