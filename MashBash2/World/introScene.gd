extends Node2D


func _ready():
	Pausemenu.dontTime=true
	Pausemenu.runningFor=0.0;
	Mashlogue.load_dialogue(
		load("res://addons/MASHLOG/dialogueSets/introTalk.tres"),
		load("res://addons/MASHLOG/iconsets/MASH.tres"))
	$split.play("link")
