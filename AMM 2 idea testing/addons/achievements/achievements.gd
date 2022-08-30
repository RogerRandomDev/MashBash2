extends CanvasLayer
const rootFile="res://addons/achievements/"
var completeAchievements=[]
func _ready():
	load_achievement_list()





#loads all our achievements for us
func load_achievement_list():
	var dir=Directory.new()
	#opens the achievement folder to pull them all
	dir.open(rootFile+"achievementList")
	var _content=dir.get_files()
	for fileName in _content:
		var file=load(rootFile+"achievementList/%s"%fileName)
		var built=file.build()
		if !completeAchievements.has(file.name):built.modulate=Color(0.5,0.5,0.5,1.)
		$achievements.add_child(built)
	
