@tool
extends Node3D

@export var predefined_position = Vector3.ZERO
@export var predefined_rotation = Vector3.ZERO
@export var predefined_scale = Vector3.ONE

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position=predefined_position
	self.rotation=predefined_rotation
	self.scale=predefined_scale
	
