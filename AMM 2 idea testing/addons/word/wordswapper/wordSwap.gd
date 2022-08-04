extends Panel

var Words
var Owned
var BaseText=""
var selectedWord=0
func _ready():
	Owned=$Owned
	Words=$RichTextLabel
	BaseText=Words.text
	updateSelectedWord()



func _input(_event):
	var dir=int(Input.is_action_just_pressed("left"))-int(Input.is_action_just_pressed("right"))
	if Input.is_action_just_pressed("confirm"):
		if BaseText.split(" ").size()<=1:return
		var removed=removeWord(selectedWord)
		if removed!=null:Word.storedWords.push_back(removed)
		updateOwned()
	if dir==0:return
	selectedWord=clamp(selectedWord-dir,0,BaseText.split(" ").size()-2)
	updateSelectedWord()


#updates the current chosen word
func updateSelectedWord():
	var _splitWords=BaseText.split(" ")
	buildPhrase(_splitWords)


#removes currently chosen word and returns it for you
func removeWord(id):
	
	var _splitWords=BaseText.split(" ")
	
	var out=_splitWords[id]
	_splitWords.remove_at(id)
	selectedWord=0
	buildPhrase(_splitWords,false)
	BaseText=Words.text
	buildPhrase(_splitWords)
	return out
	

#rebuilds the phrase once taken apart
func buildPhrase(_splitWords,withEffect=true):
	Words.text=""
	for i in _splitWords.size():
		if _splitWords[i]=="":continue
		if(i==selectedWord&&withEffect&&_splitWords.size()!=1):
			Words.text+="[pull]"
			Words.text+=_splitWords[i]
			Words.text+="[/pull] "
			continue
		Words.text+=_splitWords[i]
		if i!=_splitWords.size()-1:Words.text+=" "


#updates the owned words
func updateOwned():
	Owned.text=""
	for word in Word.storedWords:
		Owned.text+=word+" "
	Owned.text.trim_suffix(" ")
