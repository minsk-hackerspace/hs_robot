
MAIN_SESSION=$(screen -ls | grep main | awk '{print $1}')

stop_sinatra () {

	if [ "$MAIN_SESSION" != "" ]; then
		echo "hs_robot: stop main, session: $MAIN_SESSION"
		screen -S $MAIN_SESSION -X quit
	else
		echo "hs_robot: main not started"
	fi

	sleep 2

	sudo killall ruby
}

start_sinatra () {

	if [ "$MAIN_SESSION" != "" ]; then
		echo "hs_robot: main is running, session: $MAIN_SESSION"
	else
		echo "hs_robot: starting main"
		screen -c $ROBOT_HOME/startup/screenrc/main.screenrc -S main -d -m ruby $ROBOT_HOME/web/main.rb -o 0.0.0.0 -p 8081
	fi

}
