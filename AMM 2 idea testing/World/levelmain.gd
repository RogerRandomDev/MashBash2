extends Node2D



func _ready():
	Sound.playSong("song0",-5)
	Mashlogue.load_dialogue(
		load("res://addons/MASHLOG/dialogueSets/tutorialLevel.tres"),
		load("res://addons/MASHLOG/iconsets/MASH.tres"))
