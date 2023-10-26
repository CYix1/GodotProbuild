extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var scene= load("res://Prefabs/Sphere.tscn")
	var inst=scene.instantiate()
	inst.owner=self
	inst.set_owner(self)
	add_child(inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
