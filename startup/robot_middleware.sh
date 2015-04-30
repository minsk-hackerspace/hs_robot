
CONNECTOR_SESSION=$(screen -ls | grep connector | awk '{print $1}')

stop_middleware () {

	if [ "$CONNECTOR_SESSION" != "" ]; then
		echo "hs_robot: stop connector, session: $CONNECTOR_SESSION"
		screen -S $CONNECTOR_SESSION -X quit
	else
		echo "hs_robot: connector not started"
	fi

	sudo killall ruby
}

start_middleware () {

	if [ "$CONNECTOR_SESSION" != "" ]; then
		echo "hs_robot: connector is running, session: $CONNECTOR_SESSION"
	else
		echo "hs_robot: starting connector"
		screen -c $ROBOT_HOME/startup/screenrc/connector.screenrc -S connector -d -m ruby $ROBOT_HOME/web/connector.rb
	fi
}
