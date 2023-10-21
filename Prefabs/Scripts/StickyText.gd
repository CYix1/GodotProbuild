@tool
extends Node3D

@export var text = "Hello World"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label3D.text=text

