@tool
extends Button
class_name PrefButton
var index=0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.pressed.connect(new_press)

func new_press():
	ProbuilderVars.objs[index].resource_name
	ProbuilderVars.selected_index=index
	#print(ProbuilderVars.selected_index)
# Called every frame. 'delta' is the elapsed time since the previous frame.

