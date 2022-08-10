extends Node

var sounds=[]
var music=AudioStreamPlayer.new()

func _ready():
	self.process_mode=Node.PROCESS_MODE_ALWAYS
	add_child(music)



func play(sound):
	var player=AudioStreamPlayer.new()
	add_child(player)
	sounds.push_back(player)
	player.stream=load("res://addons/Sound/Sounds/World/%s.wav"%sound)
	player.connect("finished",removeSound,[player])
	player.play()
	
#plays song
func playSong(song):
	music.stream=load("res://addons/Sound/Sounds/Music/%s.mp3"%song)
	music.play()



func removeSound(soundPlayer):
	sounds.erase(soundPlayer)
	soundPlayer.queue_free()
