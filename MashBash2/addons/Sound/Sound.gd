extends Node

var sounds=[]
var music=AudioStreamPlayer.new()
var lastMusic=null
func _ready():
	self.process_mode=Node.PROCESS_MODE_ALWAYS
	add_child(music)



func play(sound,db=0.):
	if sound=="no_man_voice":return
	var player=AudioStreamPlayer.new()
	add_child(player)
	sounds.push_back(player)
	player.volume_db=db
	
	player.stream=load("res://addons/Sound/Sounds/World/%s.wav"%sound)
	player.connect("finished",func(e=player):removeSound(e))
	player.play()
	
#plays song
func playSong(song,db=0.):
	if lastMusic!=null:
		lastMusic.queue_free();lastMusic=null
	lastMusic=music
	var tween:Tween=create_tween()
	tween.tween_property(lastMusic,"volume_db",-40.,1.0)
	music=AudioStreamPlayer.new()
	add_child(music)
	music.stream=load("res://addons/Sound/Sounds/Music/%s.mp3"%song)
	music.volume_db=db
	music.play()
	tween.parallel().tween_property(music,"volume_db",db,1.0)



func removeSound(soundPlayer):
	sounds.erase(soundPlayer)
	soundPlayer.queue_free()
