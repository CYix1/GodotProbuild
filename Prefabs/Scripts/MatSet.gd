@tool
extends CSGCombiner3D

@export var m_material : Material

@export var testdaw: bool = false : set = set_button2
func set_button2(new_value: bool) -> void:
	test()
func _ready():
	test()
			
func test():
	for child in get_children():
		if child is CSGBox3D or child is CSGCylinder3D or child is CSGMesh3D or child is CSGSphere3D:	
			child.set_material(m_material)

