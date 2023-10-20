@tool
extends Node
var label_text="Moment"


var firstPos=Vector3.ZERO
var secondPos=Vector3.ZERO
var thirdPos=Vector3.ZERO

var instantiated_obj=null

var mouse_position = Vector2()
var z_depth=40
var position_3D= Vector3()
var objs=[preload("res://Prefabs/Cube.tscn"),preload("res://Prefabs/Sphere.tscn"),preload("res://Prefabs/Capsule.tscn")]
var selected_index=0
var mode = 0

var current_scene = null

func _ready():

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	selected_index=0
	mode=0
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