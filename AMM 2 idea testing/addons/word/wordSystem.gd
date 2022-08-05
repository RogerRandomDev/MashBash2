extends Node

var storedWords=[]
var wordSwap
var hoveringObject=null
var lastStored=[]
func _ready():
	wordSwap=load("res://addons/word/wordswapper/wordSwap.tscn").instantiate()
	add_child(wordSwap)
	wordSwap=wordSwap.get_child(0)
	swapVisible(false)
	process_mode=Node.PROCESS_MODE_ALWAYS


func _input(event):
	#opens the hovered item
	if Input.is_action_just_pressed("confirm")&&hoveringObject!=null&&!wordSwap.get_parent().visible:
		updateSwapper()
		lastStored=storedWords.duplicate(true)
	#resets the words to what it was when you opened the current item
	if Input.is_action_just_pressed("reset")&&wordSwap.get_parent().visible:
		storedWords=lastStored.duplicate(true)
		updateSwapper()
	#closes the swapper and updates the item to match it
	if Input.is_action_just_pressed("misc")&&wordSwap.get_parent().visible:
		hoveringObject.modifyTo(wordSwap.BaseText.split(" "))
		swapVisible(false)
#updates the wordswapper layer
func updateSwapper():
	wordSwap.BaseText=hoveringObject.getText()
	wordSwap.nameLabel.text=hoveringObject.getName()
	swapVisible(true)
	wordSwap.updateOwned()
	wordSwap.updateSelectedWord()


#changes visibility and process mode for it
#done so it can be "paused" when not in use
#just fixes some minor problems but easy fix so meh good enough
func swapVisible(show):
	wordSwap.activeSet=0
	wordSwap.selectedWord=0
	wordSwap.set_process(show)
	wordSwap.set_process_input(show)
	wordSwap.set_process_internal(show)
	wordSwap.set_process_unhandled_input(show)
	wordSwap.get_parent().visible=show
	get_tree().paused=show
