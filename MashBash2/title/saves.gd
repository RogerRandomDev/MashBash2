extends Node


const defaultSave=[
	["Roger",903.275],
	["Also Roger",1200.356],
	["Still Roger",1434.694],
	["Yep, Still Roger",2693.734],
	["You know who",4893.987]
]
var curSave=[]
const saveLocation="user://Save.dat"
func _ready():
	#default to generate the save
	if !FileAccess.file_exists(saveLocation):
		curSave=defaultSave
		saveGame()
	else:
		loadSaveGame()
	#loads the saved game leaderboard

func saveGame():
	var file=FileAccess.open(saveLocation,FileAccess.WRITE)
	#need to conver to buffer instead of just plain text later
	file.store_line(var_to_str(curSave))


func loadSaveGame():
	var file=FileAccess.open(saveLocation,FileAccess.READ)
	#needs to convert to a buffer instead of plain text later
	curSave=str_to_var(file.get_as_text())


func addNewTime(timeIn):
	curSave.append(["YOU",timeIn])
	curSave.sort_custom(func(a,b):return b[1]>a[1])
	curSave.pop_back()
	saveGame()
