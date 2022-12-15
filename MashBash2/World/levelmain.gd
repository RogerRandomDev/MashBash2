extends Node2D


var alreadyTeleported=0
func _ready():
	Pausemenu.get_node("CanvasLayer").visible=true
	Pausemenu.dontTime=true
	Sound.playSong("song0",-5)
	await get_tree().process_frame
	Mashlogue.load_dialogue(
		load("res://addons/MASHLOG/dialogueSets/tutorialLevel.tres"),
		load("res://addons/MASHLOG/iconsets/MASH.tres"))
	#stops the generation signal from causing trouble
	await get_tree().process_frame
	Pausemenu.dontTime=true
	Pausemenu.runningFor=0.0;
	#checks if it was the player teleporting
	$items/itemResource2.get_child(0).connect("use_item",func(ent,action):if(ent==Word.player&&action=="teleporter"):teleportFirst())
	$items/itemResource6.get_child(0).connect("use_item",func(ent,action):if(ent==Word.player&&action=="teleporter"):teleportSecond())
	$items/itemResource11.get_child(0).connect("use_item",func(ent,action):if(action=="openDoor"):doorFirst())
	$items/itemResource13.get_child(0).connect("use_item",func(ent,action):if(ent==Word.player&&action=="teleporter"):introduceWords())

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

func introduceWords():
	if alreadyTeleported>3:return
	alreadyTeleported+=1
	Mashlogue.load_dialogue(
		preload("res://addons/MASHLOG/dialogueSets/explainWordSwap.tres"),
		preload("res://addons/MASHLOG/iconsets/MASH.tres"))

func _process(_delta):Word.swapsLeft=999
