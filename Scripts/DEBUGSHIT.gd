@tool
extends CSGCombiner3D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.position)
	print(self.rotation)
	print(self.scale)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
