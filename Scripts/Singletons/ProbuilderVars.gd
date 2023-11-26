@tool
extends Node

#TODO FIX THIS SHIT. u don't need evetyhing!
var label_text="Moment"
var state_text="currentState"
var selected_index=0
var instantiated_obj=null
var p1:Vector3
var p2:Vector3

#events if specific values are changed I hope
var block=CustomDataType.new(true)
var snap_objects=CustomDataType.new(false)
var all_axis_scale=CustomDataType.new(false)
var raycast_ground=CustomDataType.new(true)
var height_fix_after_placement= CustomDataType.new(false)
var randomXZ= CustomDataType.new(false)

var randomScaleMax= CustomDataType.new(1.0)
var scaling_factor_factor= CustomDataType.new(0.3)

var snapping_value=CustomDataType.new(Vector3.ONE)

var mouse_position = Vector2()
var z_depth=1000
var position_3D= Vector3()
var objs=[
	#preload("res://Prefabs/Bridge.tscn"),
	preload("res://Prefabs/Capsule.tscn"),
preload("res://Prefabs/Circle.tscn"),
preload("res://Prefabs/Cube.tscn"),
preload("res://Prefabs/Cylinder.tscn"),
preload("res://Prefabs/Door.tscn"),
#preload("res://Prefabs/HollowCube.tscn"),
preload("res://Prefabs/House.tscn"),
preload("res://Prefabs/Plane.tscn"),
preload("res://Prefabs/Slope.tscn"),
preload("res://Prefabs/Sphere.tscn"),
#preload("res://Prefabs/StickyText.tscn"),

preload("res://Prefabs/TempleBase.tscn"),
preload("res://Prefabs/Tree.tscn")

]

class CustomDataType:
	signal on_value_change(new_value)
	var data=false:
		get:
			return data
		set(value):
			on_value_change.emit(value)
			data = value
	func _init(v):
		data=v

func print_state():
	print("label_text:",label_text)
	print("state_text:",state_text)
	print("selected_index:",selected_index)
	print("instantiated_obj:",label_text)
	print("p1:",p1)
	print("p2:",p2)
	print("block:",block.data)
	print("snap_objects:",snap_objects.data)
	print("all_axis_scale:",all_axis_scale.data)
	print("raycast_ground:",raycast_ground.data)
	print("scaling_factor_factor:",scaling_factor_factor.data)
	print("snap_value:",snapping_value.data)
	print("fix_height:",height_fix_after_placement.data)	
	print("randomXZ:",randomXZ.data)
	print("randomScaleMax",randomScaleMax.data)
	
#NOT USED
var current_scene = null

func _ready():

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
