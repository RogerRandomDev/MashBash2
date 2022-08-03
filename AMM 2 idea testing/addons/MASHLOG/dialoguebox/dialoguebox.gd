extends CanvasLayer

var fullContents=null
var curContents=""
var _contentProgress=-1
var icon_set:iconSet
var _contentLength=0
@onready var icon=$dialoguebox/contents/iconpanel/icon
@onready var textContent=$dialoguebox/contents/speech
#signals for when an action occurs
signal nextSet
signal nextChar
signal finishedSet

#preps the timers and other needed bits and pieces
func _ready():
	$nextChar.connect('timeout',loadNextCharacter)
	$nextSet.connect('timeout',loadNextSet)
	loadNewSet(load("res://addons/MASHLOG/dialogueSets/0.tres"),preload("res://addons/MASHLOG/iconsets/MASH.tres"))


#prepares a new set of text to show to you
func loadNewSet(setContent,icons=null):
	if icons==null:icons=load("res://addons/MASHLOG/iconsets/MASH.tres")
	icon_set=icons
	icon.modulate=icons.modulate
	fullContents=setContent
	_contentProgress=-1
	$nextChar.start()
	loadNextSet()






#loads the next character in the text set
func loadNextCharacter():
	
	textContent.visible=true
	textContent.visible_characters+=1
	
	if _contentLength<=textContent.visible_characters&&$nextSet.is_stopped():
		$nextSet.start()
	else:emit_signal("nextChar")

#loads the next block of text for you
func loadNextSet():
	textContent.visible=false
	#hides all text and moves to next set in array
	textContent.visible_characters=-1
	_contentProgress+=1
	fullContents.triggerActions(_contentProgress)
	#hides text box when there is nothing left to show
	if _contentProgress>=fullContents.count_sets():
		emit_signal("finishedSet")
		$nextChar.stop()
		visible=false;return
	emit_signal("nextSet")
	#loads new text set into the text box
	textContent.text=fullContents.text_for(_contentProgress)
	#loads needed icon
	icon.texture=icon_set.get_face(fullContents.face_for(_contentProgress))
	
	icon.modulate=icon_set.modulate
	#at end to make sure it knows how many characters it will show for you
	_contentLength=textContent.get_total_character_count()
