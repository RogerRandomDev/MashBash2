extends Node

var storedWords=[]
var wordSwap
var hoveringObject=null
var lastStored=[]
var swapped=false
var swapsLeft=3
var tiles
var player
var hoveringObjects=[]
var canChange=true
var alldescriptives=[]
func _ready():
	await get_tree().process_frame
	wordSwap=load("res://addons/word/wordswapper/wordSwap.tscn").instantiate()
	add_child(wordSwap)
	wordSwap=wordSwap.get_child(0)
	swapVisible(false)
	process_mode=Node.PROCESS_MODE_ALWAYS
	loadDescriptives()
#adds all descriptives to the array
func loadDescriptives():
	var dir=DirAccess.open("res://addons/word/descriptiveIcons")
	for file in dir.get_files():
		if !alldescriptives.has(file.split(".")[0]):
			alldescriptives.append(file.split(".")[0])
	


func _input(event):
	if !canChange||Pausemenu.visible:return
	if player==null||player.locked:return
	#opens the hovered item
	if Input.is_action_just_pressed("confirm")&&hoveringObjects!=[]&&!wordSwap.get_parent().visible:
		updateSwapper()
		lastStored=storedWords.duplicate(true)
	#resets the words to what it was when you opened the current item
	if Input.is_action_just_pressed("reset")&&wordSwap.get_parent().visible:
		storedWords=lastStored.duplicate(true)
		updateSwapper()
	#closes the swapper and updates the item to match it
	if (Input.is_action_just_pressed("misc")||Input.is_action_just_pressed("exit"))&&wordSwap.get_parent().visible:
		if swapped:
			hoveringObject.Status=(wordSwap.BaseText.split(" "))
			hoveringObject.updateWordsFromOthers()
		swapVisible(false)
#updates the wordswapper layer
func updateSwapper():
	Input.action_release("confirm")
	swapped=false
	hoveringObject=hoveringObjects[hoveringObjects.size()-1]
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
	
	if !show&&swapped:
		var anim=wordSwap.get_parent().get_node("alteredLabel/AnimationPlayer")
		anim.stop()
		anim.play("alter",0.)
		Sound.play("worldchanged",-12.)
