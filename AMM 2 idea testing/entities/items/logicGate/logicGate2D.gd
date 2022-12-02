@tool
extends Sprite2D
class_name logicGate2D
#signal naming is same as buttons, so that other logic gates can treat them as one
#in essence, this is just so i can chain logic gates
signal buttonPressed()
signal buttonReleased()
const states={"OFF":preload("res://entities/items/logicGate/off.png"),"ON":preload("res://entities/items/logicGate/on.png")}
@export_enum(AND,NAND,OR,NOR,XOR,XNOR) var logic
@export var inputs:Array:
	set(value):
		inputs=value
		if(typeof(inputs[inputs.size()-1])!=TYPE_NODE_PATH):inputs[inputs.size()-1]=NodePath("/")
	get:return inputs
@export var outputs:Array:
	set(value):
		if value.size()==0:return
		
		if Engine.is_editor_hint():
			if(typeof(value[value.size()-1])!=TYPE_NODE_PATH):value[value.size()-1]=NodePath()
		outputs=value
	get:return outputs
var activeInputs=[]
var active=false
var gates=["and","nand","or","nor","xor","xnor"]
var logicSymbol=Sprite2D.new()
var logicName=Label.new()
	
#connects the logic gate to the inputs
func _ready():
	Pausemenu.showgate.connect("toggled",func(toggled):logicName.visible=toggled)
	logicName.theme=load("res://themes/basetheme.tres")
	add_child(logicName);logicName.text=gates[logic]
	centered=false
	texture=states.OFF
	add_child(logicSymbol)
	logicSymbol.texture=load("res://entities/items/logicGate/%s.png"%gates[logic])
	logicSymbol.position=Vector2(4,4.5);logicSymbol.scale=Vector2(0.4375,0.5)
	logicSymbol.self_modulate=Color(0.,1.,1.)
	logicName.scale=Vector2(0.5,0.5)
	call_deferred('update_label')
	if Engine.is_editor_hint():return
	for output in outputs.size():outputs[output]=get_node(outputs[output])
	connect("buttonPressed",func(e=true):updateSelf(e))
	connect("buttonReleased",func(e=false):updateSelf(e))
	for input in inputs:
		var _input=get_node(input)
		_input.connect("buttonPressed",func(e=_input):activateInput(e))
		_input.connect("buttonReleased",func(e=_input):releaseInput(e))
	checkLogic(activeInputs.size(),inputs.size())



func activateInput(_input):
	activeInputs.append(_input)
	checkLogic(activeInputs.size(),inputs.size())
func releaseInput(_input):
	activeInputs.erase(_input)
	checkLogic(activeInputs.size(),inputs.size())
	

func updateSelf(isPressed):
	if isPressed:texture=states.ON
	else:texture=states.OFF


#deals with output handling
func updateOutputs():
	Word.swapped=true
	for output in outputs:
		if(output.get_class()=="Marker2D")&& !output.Status.has("locked"):
			if texture==states.ON:output.Status.append("open")
			else:
				#this stops you from farming one door for open and prevents you from pulling stuff i dont like
				if output.Status.has("open"):output.Status.remove_at(output.Status.find("open"))
				else:output.Status.append("locked")
			
			output.Status.append("_")
			output.modifyTo(output.Status)
	Word.swapped=false
#checsk based on logic gates
func checkLogic(_in,_allIn):
	var checked=false
	#the gate types
	match logic:
		0:checked = _in==_allIn
		1:checked = _in<_allIn
		2:checked = _in>0
		3:checked = _in==0
		4:checked = _in>0&&_in<_allIn
		5:checked = !(_in>0&&_in<_allIn)
	
	if checked&&!active:
		emit_signal("buttonPressed");updateOutputs();active=true
	else:if !checked&&active:
		emit_signal("buttonReleased");updateOutputs();active=false


	call_deferred("update_label")

func update_label():
	await("idle_frame")
	logicName.position=-logicName.size/4+Vector2(4,-3)
