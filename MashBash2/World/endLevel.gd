extends Node2D


func _ready():
	Pausemenu.dontTime=true;
	
	fillLeaderBoard();
	showCelebratorMessages()


#fills leaderboard with previous scores
func fillLeaderBoard():
	pass


const timeMessages={
	300:"The speediest runner!",
	600:"A speedrunner, I see.",
	900:"Now that's pretty fast!",
	1200:"Not bad at all!",
	1800:"Could be better...",
	2400:"Wanna try again?"
}
#shows user time and message based on how long they took
func showCelebratorMessages():
	var message="Maybe find a playthrough first?"
	$yourscore/Label2.text=Pausemenu.getTime()
	var trueTime=Pausemenu.runningFor
	for time in timeMessages:if(trueTime<time):
			message=timeMessages[time];break
	$yourscore/Label3.text=message
