extends itemStatus

#signal naming is same as buttons, so that other logic gates can treat them as one
#in essence, this is just so i can chain logic gates
signal buttonPressed()
signal buttonReleased()
const states={"OFF":preload("res://entities/items/logicGate/off.png"),"ON":preload("res://entities/items/logicGate/on.png")}
const particles=preload("res://entities/items/logicGate/activeLogic.tres")
var inputs:Array=[]
var outputs:Array=[]
var activeInputs=[]
var active=false

var gates=["and","nand","or","nor","xor","xnor"]
var logicSymbol=Sprite2D.new()
var logicName=Label.new()
var logic=-1
var root=null
var myPath=null
var particleEmitter=null
#connects the logic gate to the inputs
func _ready():
	if Engine.is_editor_hint():return
	
	logic=-1
	justSwap=false
	root=get_parent()
	for id in root.Status:if gates.has(id):logic = gates.find(id)
	if logic!=-1:logicName.text=gates[logic]
	logicName.visible=logic!=-1
	logicSymbol.visible=logic!=-1
	
	if get_child_count()!=0:
		call_deferred('checkLogic',activeInputs.size(),inputs.size())
		return
	particleEmitter=createParticles(particles,32,0.0,false,0.25)
	particleEmitter.global_position=global_position+Vector2(4,4)
	logicName.theme=load("res://themes/basetheme.tres")
	add_child(logicName);
	root.sprite.centered=false
	root.sprite.texture=states.OFF
	root.sprite.add_child(logicSymbol)
	inputs=[]
	outputs=[]
	#gets the inputs and outputs
	for group in root.get_groups():
		group=String(group);var mod=group.replace("INP_","").replace("OUT_","")
		if mod==group:continue
		var node=root.get_parent().get_parent().get_node(mod)
		if(node.get_class()!="Marker2D"):node=node.get_node("ItemResource")
		if group.begins_with("INP_"):inputs.append(node)
		else:outputs.append(node)
	
	#sets up the symbol
	logicSymbol.texture=load("res://entities/items/logicGate/%s.png"%gates[logic])
	logicSymbol.position=Vector2(4,4.5);logicSymbol.scale=Vector2(0.4375,0.5)
	logicSymbol.self_modulate=Color(0.,1.,1.)
	logicName.scale=Vector2(0.5,0.5)
	call_deferred('update_label')
	
	Pausemenu.showgate.connect("toggled",func(toggled):logicName.visible=toggled)
	connect("buttonPressed",func(e=true):updateSelf(e))
	connect("buttonReleased",func(e=false):updateSelf(e))
	
	call_deferred('connectInputs')
#connects to the inputs
func connectInputs():
	for _input in inputs:
		var inp=_input.get_node_or_null("ScriptHolder")
		inp.connect("buttonPressed",func(e=_input):activateInput(e))
		inp.connect("buttonReleased",func(e=_input):releaseInput(e))
		if inp.get("pressed"):activateInput(inp)
		else:if inp.get("active"):activateInput(inp)
		else:if activeInputs.has(inp):releaseInput(inp)
	call_deferred('checkLogic',activeInputs.size(),inputs.size())



func activateInput(_input):
	if activeInputs.has(_input)||_input.get_class()!="Marker2D":return
	if logic==-1:return
	activeInputs.append(_input)
	checkLogic(activeInputs.size(),inputs.size())
func releaseInput(_input):
	activeInputs.erase(_input)
	if logic==-1:return
	checkLogic(activeInputs.size(),inputs.size())
	

func updateSelf(isPressed):
	if isPressed:root.sprite.texture=states.ON
	else:root.sprite.texture=states.OFF
	if(particleEmitter!=null):particleEmitter.emitting=isPressed!=false


#deals with output handling
func updateOutputs():
	#blocks client updates
	if Link.link_root!=null&&!Link.link_root.is_host:return
	
	
	Word.swapped=true
	for output in outputs:
		if(output.get_class()=="Marker2D"):
			if output.get_node("ScriptHolder").has_method("logicAction"):
				output.get_node("ScriptHolder").logicAction(root.sprite.texture==states.ON)
			else:
				if root.sprite.texture==states.ON:
					if !output.Status.has(output.HeldResource.logicOff
					):output.Status.append(output.HeldResource.logicOn)
					else:output.Status.remove_at(
						output.Status.find(output.HeldResource.logicOff))
				else:
					#this stops you from farming one door for open and prevents you from pulling stuff i dont like
					if output.Status.has(output.HeldResource.logicOn
					):output.Status.remove_at(output.Status.find(output.HeldResource.logicOn))
					else:output.Status.append(output.HeldResource.logicOff)
				
				output.Status.append("_")
				output.modifyTo(output.Status)
	Word.swapped=false
#checsk based on logic gates
func checkLogic(_in,_allIn):
	var checked=false
	#the gate types
	match logic:
		-1:checked=false
		0:checked = _in==_allIn
		1:checked = _in<_allIn||_allIn==0
		2:checked = _in>0
		3:checked = _in==0
		4:checked = _in>0&&_in<_allIn
		5:checked = !(_in>0&&_in<_allIn)
	if root.Status.has("disabled"):active=false
	if root.Status.has("active"):active=true
	if checked&&!active:
		emit_signal("buttonPressed");updateOutputs();active=true
	elif !checked&&active:
		emit_signal("buttonReleased");updateOutputs();active=false
	

	call_deferred("update_label")

func update_label():
	logicName.position=-logicName.size/4+Vector2(4,-3)


