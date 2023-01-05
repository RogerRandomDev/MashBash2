extends CanvasLayer
const rootFile="res://addons/achievements/"
var completeAchievements=[]
func _ready():
	await get_tree().process_frame
	load_achievement_list.call_deferred()





#loads all our achievements for us
func load_achievement_list():
	#opens the achievement folder to pull them all
	var dir= DirAccess.open(rootFile+"achievementList")
	var _content=dir.get_files()
	for fileName in _content:
		var file=load(rootFile+"achievementList/%s"%fileName)
		var built=file.build()
		if !completeAchievements.has(file.name):built.modulate=Color(0.5,0.5,0.5,1.)
		$achievements.add_child(built)
	
