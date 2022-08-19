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
		outputs=value
		if(typeof(outputs[outputs.size()-1])!=TYPE_NODE_PATH):outputs[outputs.size()-1]=NodePath("/")
	get:return outputs
var activeInputs=[]
var active=false
#connects the logic gate to the inputs
func _ready():
	centered=false
	texture=states.OFF
	if Engine.is_editor_hint():return
	connect("buttonPressed",updateSelf,[true])
	connect("buttonReleased",updateSelf,[false])
	for input in inputs:
		var _input=get_node(input)
		_input.connect("buttonPressed",activateInput,[_input])
		_input.connect("buttonReleased",releaseInput,[_input])




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
	pass

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
