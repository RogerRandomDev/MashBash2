extends Node2D


var alreadyTeleported=0
func _ready():
#	Sound.playSong("song0",-5);Pausemenu.get_node("logic").visible=false
#	Mashlogue.load_dialogue(
#		load("res://addons/MASHLOG/dialogueSets/tutorialLevel.tres"),
#		load("res://addons/MASHLOG/iconsets/MASH.tres"))
	#checks if it was the player teleporting
	$items/itemResource2.connect("use_item",func(ent,action):if(ent==Word.player&&action=="teleporter"):teleportFirst())
	$items/itemResource6.connect("use_item",func(ent,action):if(ent==Word.player&&action=="teleporter"):teleportSecond())
	$items/itemResource11.connect("use_item",func(ent,action):if(action=="openDoor"):doorFirst())

func teleportFirst():
	if alreadyTeleported>0:return
	alreadyTeleported+=1
	Mashlogue.load_dialogue(
		preload("res://addons/MASHLOG/dialogueSets/firstTeleport.tres"),
		preload("res://addons/MASHLOG/iconsets/MASH.tres"))

func teleportSecond():
	if alreadyTeleported>1:return
	alreadyTeleported+=1
	Mashlogue.load_dialogue(
		preload("res://addons/MASHLOG/dialogueSets/buttonsnboxes.tres"),
		preload("res://addons/MASHLOG/iconsets/MASH.tres"))

func doorFirst():
	if alreadyTeleported>2:return
	alreadyTeleported+=1
	Mashlogue.load_dialogue(
		preload("res://addons/MASHLOG/dialogueSets/lasers.tres"),
		preload("res://addons/MASHLOG/iconsets/MASH.tres"))
