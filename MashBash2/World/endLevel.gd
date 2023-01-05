extends Node2D


func _ready():
	Pausemenu.dontTime=true;
	Saves.addNewTime(Pausemenu.runningFor)
	fillLeaderBoard();
	showCelebratorMessages()


#fills leaderboard with previous scores
func fillLeaderBoard():
	var leaderBoard=get_node("LEADERBOARD");var i=-1
	for child in leaderBoard.get_children():
		if(i==-1):
			i+=1;continue
		child.text=formatSave(i);i+=1
func formatSave(i):
	var add="%s"
	if Saves.curSave[i][0]=="YOU":add="[color=#0f0]%s[/color]"
	var toAdd=Saves.curSave[i][0]+":"
	for a in 12-Saves.curSave[i][0].length():toAdd+=" "
	toAdd+=formatTime(Saves.curSave[i][1])
	return add%toAdd
func formatTime(time):
	#convert to minutes and seconds
	var minutes=int(time/60)
	var seconds=int(time)%60
	seconds = seconds+floor((time-floor(time))*1000)/1000
	var secondsString=str(seconds)
	if(!secondsString.contains(".")):secondsString+=".000"
	while !secondsString.split(".")[1].length()==3:secondsString+="0"
	var outputTime=("0" if minutes<10 else "")+str(minutes)+":"+("0" if seconds < 10 else "")+secondsString
	return outputTime
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
