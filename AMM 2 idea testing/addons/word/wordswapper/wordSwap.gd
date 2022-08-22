extends Panel

var Words
var Owned
var nameLabel
var BaseText=""
var selectedWord=0
var activeSet=0
var activeObject

func _ready():
	Owned=$labels/Owned
	Words=$labels/RichTextLabel
	nameLabel=$labels/Label2
	BaseText=Words.text
	updateSelectedWord()
	$labels/Label2/swapsleft.self_modulate=Color.WHITE



func _input(_event):
	
	var dir=int(Input.is_action_just_pressed("left"))-int(Input.is_action_just_pressed("right"))
	if Input.is_action_just_pressed("up")||Input.is_action_just_pressed("down"):
		activeSet=1-activeSet
		if activeSet==1&&Word.storedWords.size()<1:activeSet=0
		if activeSet==0&&BaseText.length()<2:activeSet=1
		selectedWord=0
		updateOwned()
		updateSelectedWord()
	if Input.is_action_just_pressed("confirm"):
		
		Input.action_release("confirm")
		if selectedWord==-1:return
		if activeSet==0&&Word.swapsLeft>0:
			if BaseText.split(" ").size()<=1:return
			var removed=removeWord(selectedWord)
			if removed==null:
				cantAnim();return
			Word.swapsLeft-=1
			Word.swapped=true
			if removed!=null:Word.storedWords.push_back(removed)
		elif Word.swapsLeft<=0&&activeSet==0:cantAnim()
		if activeSet==1:
			#makes sure words don't clash
			if !Word.hoveringObject.checkWordInput(Word.storedWords[selectedWord]):
				var a = get_parent().get_node("AnimationPlayer")
				if a.current_animation!="":
					a.advance(a.current_animation_length-a.current_animation_position)
					a.stop()
				a.play("cantDo",0.0)
				Sound.play("cant")
				return
			
			var added=Word.storedWords[selectedWord]
			insertWord(added)
			
			Word.storedWords.remove_at(selectedWord)
			if Word.storedWords.size()==0:activeSet=0
			updateFromInput(added)
			updateSelectedWord()
			selectedWord=0
			Word.swapped=true
		updateOwned()
	if activeSet==0&&BaseText.split(" ").size()<2:activeSet=1
	#clamps the chosen words to the size of words you can choose
	if activeSet==0:selectedWord=clamp(selectedWord-dir,0,BaseText.split(" ").size()-2)
	if activeSet==1:selectedWord=clamp(selectedWord-dir,0,Word.storedWords.size()-1)
	
	updateSelectedWord()
#anim for cant
func cantAnim():
	
	var a = get_parent().get_node("AnimationPlayer")
	if a.current_animation!="":a.advance(a.current_animation_length-a.current_animation_position)
	a.stop();a.play("pulseRed",0.0)
	Sound.play("cant")

#updates the current chosen word
func updateSelectedWord():
	var _splitWords=BaseText.split(" ")
	Words.text=buildPhrase(_splitWords)
	$labels/Label2/swapsleft.text="ALTERCATIONS REMAINING: %s"%Word.swapsLeft


#removes currently chosen word and returns it for you
func removeWord(id):
	if !Word.hoveringObject.canPull():return null
	var _splitWords=BaseText.split(" ")
	
	var out=_splitWords[id]
	_splitWords.remove_at(id)
	selectedWord=0
	#can not remove moveable from items
	if out=="moveable":return null
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


#input word checker for the items
func updateFromInput(inWord):
	if(inWord=="KEY"&&Word.hoveringObject.Status.has("locked")):
		BaseText=BaseText.replace("locked","open").replace("KEY","")
