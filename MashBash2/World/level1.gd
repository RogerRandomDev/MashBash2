extends Node2D



func _ready():
	Word.swapsLeft=3
	Mashlogue.load_dialogue(
		load("res://addons/MASHLOG/dialogueSets/level1.tres"),
		load("res://addons/MASHLOG/iconsets/MASH.tres"))
