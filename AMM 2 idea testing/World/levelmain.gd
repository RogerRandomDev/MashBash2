extends Node2D


var alreadyTeleported=false
func _ready():
	Sound.playSong("song0",-5)
#	Mashlogue.load_dialogue(
#		load("res://addons/MASHLOG/dialogueSets/tutorialLevel.tres"),
#		load("res://addons/MASHLOG/iconsets/MASH.tres"))
	#checks if it was the player teleporting
	$itemResource2.connect("use_item",func(ent,action):if(ent==Word.player&&action=="teleporter"):teleportFirst())

func teleportFirst():
	if alreadyTeleported:return
	alreadyTeleported=true
	Mashlogue.load_dialogue(
		load("res://addons/MASHLOG/dialogueSets/firstTeleport.tres"),
		load("res://addons/MASHLOG/iconsets/MASH.tres"))
