extends Button

var mesh_type=""


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed",new_press)
	pass # Replace with function body.

func new_press():
	print("dwaib")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
