@tool
extends EditorPlugin

#the Editowindow, which is shown in the dock left!
var object_window
	
	
func _enter_tree():
	#loading the scene with the dock and setup dock and plugin
	
	object_window= preload("res://addons/QuickMeshPlacer/object_window.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL,object_window)
	#not needed at all
	add_custom_type("pref_Btn","Button",preload("res://addons/QuickMeshPlacer/prefButton.gd"),preload("res://icon.svg"))
	
func _exit_tree():
	#freeing shit
	remove_control_from_docks(object_window)
	object_window.free()
	remove_custom_type("pref_Btn")

#need to return true, so _forward_3d_gui_input is called!
func _handles(object):
	return true
	
var firstEvent=null
var secondEvent=null
var collisionParent=null
#GET THE FUCKING MOUSEPOSITION GOD DAMMIT
func _forward_3d_gui_input(camera, event):
	
	if event is InputEventMouseMotion:
		set_mouse_position(camera,event.position)	
	if event is InputEventMouseButton and event.pressed and event.button_index== 1:
		customRayCast(camera,event.position,event )
	if event is InputEventMouseButton and event.is_pressed():
		if firstEvent == null:
			firstEvent=event
			ProbuilderVars.instantiated_obj=ProbuilderVars.objs[ProbuilderVars.selected_index].instantiate()
			var Owner=collisionParent.get_node("Level").get_parent().get_parent()
			Owner.add_child(ProbuilderVars.instantiated_obj)
			
			#code to set instantiated obj as persistent
			ProbuilderVars.instantiated_obj.owner=Owner
			ProbuilderVars.instantiated_obj.set_owner(Owner)
			
			
			ProbuilderVars.firstPos=colPos
			#little thing
			colPos.y=0
			ProbuilderVars.instantiated_obj.position=colPos
			print("first click")
		elif secondEvent == null  and firstEvent:
			secondEvent=event
			print("second click")
		elif firstEvent and secondEvent:
			firstEvent = null
			secondEvent= null
			print("reset")
	if firstEvent and secondEvent==null and event is InputEventMouseMotion:
		var scalingfactor=(event.position-firstEvent.position).length()
		print(scalingfactor)
		ProbuilderVars.instantiated_obj.scale=Vector3(scalingfactor,scalingfactor,scalingfactor)
			
	
#set 2d/3D mouse position
func set_mouse_position(camera,pos):
	ProbuilderVars.mouse_position= pos
	ProbuilderVars.position_3D= camera.project_position(ProbuilderVars.mouse_position,ProbuilderVars.z_depth)
	
#Raycasting from camera to mouse 3d Position!
func customRayCast(camera :Camera3D, pos:Vector2,event ):
	ProbuilderVars.mouse_position= pos
	
	#Raycast specific things
	var space = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(camera.global_position,
			 ProbuilderVars.position_3D)
	query.collide_with_areas=true
	var collision = space.intersect_ray(query)
	
	if collision: # RaycastHit
		ProbuilderVars.label_text=collision.collider.name
		#Call next method
		if collision.collider.name == "Ground":
			collisionParent=collision.collider
			#handleinput(collision.position,collision.collider,event)
		
	else:# no RaycastHit
		ProbuilderVars.label_text="no raycasthit!"
		pass

var scaling=false

#ok what should happen if raycast hitted and do stuff?
#the main tool functionality!
func handleinput(colPos: Vector3,collisionParent: Node3D,event):
	#var LevelNode = collisionParent.get_node("Level")		
	#printChildNodeNames(get_child_count())

	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				# When left mouse button is pressed, set the object's position to the mouse position.
				
				# Enable scaling while holding left mouse button
				scaling = true
				
			else:
				ProbuilderVars.secondPos=colPos
				# When left mouse button is released, disable scaling
				scaling = false
	

#recursive function to print the fucking tree
func printChildNodeNames(node,indent="-"):
	for child in node.get_children():
		print(indent,child.name)
		# Recursively call the function for children of the current child
		printChildNodeNames(child,indent+"-")
	

