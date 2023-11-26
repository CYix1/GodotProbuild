@tool
extends Node3D

@export_range(1,50) var numSteps = 10
@export_range(0.1,10) var stepHeight = 1.0
@export_range(0.1,10) var stepRadius = 1.0
@export_range(1,360) var rotationAngle = 10

@export var clear_btn: bool = false : set = set_button2
func set_button2(new_value: bool) -> void:
	clear($".")
	
@export var spawn_btn: bool = false : set = set_button
func set_button(new_value: bool) -> void:
	test()

func test():
	clear($".")
	stepHeight = ($CSGCylinder3D.height/  numSteps)

	for i in range(numSteps):
		add_stair(i)
		
func add_stair(index):
	var stair = CSGBox3D.new()


	
	var stairDistance = stepRadius / numSteps


	add_child(stair)	
	stair.owner= get_node(".")
	var h=min(index*stepHeight,$CSGCylinder3D.height)
	
	stair.translate(Vector3(0.0, h, 0))
	
	stair.rotate_y((index * rotationAngle))
	stair.translate_object_local(Vector3(0.87,0, 0))
	
	stair.scale=Vector3(1,0.1,0.5)

	
func clear(node):
	for n in node.get_children():
		if "CSGCylinder3D" in str(n):
			continue

		node.remove_child(n)
		n.queue_free()
	

