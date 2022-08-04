extends Panel

var Words
var Owned
var BaseText=""
var selectedWord=0
var activeSet=0
var activeObject
func _ready():
	Owned=$Owned
	Words=$RichTextLabel
	BaseText=Words.text
	updateSelectedWord()



func _input(_event):
	var dir=int(Input.is_action_just_pressed("left"))-int(Input.is_action_just_pressed("right"))
	if Input.is_action_just_pressed("up")||Input.is_action_just_pressed("down"):
		activeSet=1-activeSet
		if activeSet==1&&Word.storedWords.size()<1:activeSet=0
		selectedWord=0
		updateOwned()
		updateSelectedWord()
	if Input.is_action_just_pressed("confirm"):
		if activeSet==0:
			if BaseText.split(" ").size()<=1:return
			var removed=removeWord(selectedWord)
			if removed!=null:Word.storedWords.push_back(removed)
			
		if activeSet==1:
			var added=Word.storedWords[selectedWord]
			insertWord(added)
			Word.storedWords.remove_at(selectedWord)
			if Word.storedWords.size()==0:activeSet=0
			updateSelectedWord()
			selectedWord=0
			
		updateOwned()
		
	if dir==0:return
	#clamps the chosen words to the size of words you can choose
	if activeSet==0:selectedWord=clamp(selectedWord-dir,0,BaseText.split(" ").size()-2)
	if activeSet==1:selectedWord=clamp(selectedWord-dir,0,Word.storedWords.size()-1)
	
	updateSelectedWord()


#updates the current chosen word
func updateSelectedWord():
	var _splitWords=BaseText.split(" ")
	Words.text=buildPhrase(_splitWords)


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
		if(i==selectedWord&&withEffect&&_splitWords.size()!=1&&activeSet==0):
			Words.text+="[pull]"
			Words.text+=_splitWords[i]
			Words.text+="[/pull] "
			continue
		Words.text+=_splitWords[i]
		if i!=_splitWords.size()-1:Words.text+=" "
	updateOwned()
	return Words.text


#updates the owned words
func updateOwned():
	Owned.text=""
	for word in Word.storedWords.size():
		if selectedWord==word&&activeSet==1:
			Owned.text+="[pull]"
			Owned.text+=Word.storedWords[word]
			Owned.text+="[/pull] "
			continue
		Owned.text+=Word.storedWords[word]+" "


#inserts word into current phrase
func insertWord(_word):
	var _splitWords=BaseText.split(" ")
	_splitWords.insert(_splitWords.size()-1,_word)
	BaseText=buildPhrase(_splitWords,false)
	buildPhrase(_splitWords)
	
	
