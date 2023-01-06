extends Node2D



func _ready():
	Word.swapsLeft=3
	Word.canChange=true
	Word.player.canVacuum=true
	Pausemenu.get_node("Controls/Movement").visible=true
	Pausemenu.get_node("Controls/Interact").visible=true
	Pausemenu.get_node("Controls/ClosePause").visible=true
	Pausemenu.get_node("Controls/Vacuum").visible=true
	Mashlogue.load_dialogue(
		load("res://addons/MASHLOG/dialogueSets/level1.tres"),
		load("res://addons/MASHLOG/iconsets/MASH.tres"))
