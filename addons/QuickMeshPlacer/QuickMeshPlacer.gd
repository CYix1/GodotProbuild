@tool
extends EditorPlugin

#the Editowindow, which is shown in the dock left!
var object_window
	
	
func _enter_tree():
	#loading the scene with the dock and setup dock and plugin
	
	object_window= preload("res://addons/QuickMeshPlacer/object_window.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL,object_window)
	#not needed at all
	add_custom_type("Pref_Btn","Button",preload("res://addons/QuickMeshPlacer/prefButton.gd"),preload("res://icon.svg"))
	
func _exit_tree():
	#freeing shit
	remove_control_from_docks(object_window)
	object_window.free()
	remove_custom_type("pref_Btn")

#need to return true, so _forward_3d_gui_input is called!
func _handles(object):
	return true
			
#random Variables for logic
var firstEvent=null
var secondEvent=null
var thirdEvent=null
var collisionParent=null
var collisionPosition=null

#GET THE FUCKING MOUSEPOSITION GOD DAMMIT
func _forward_3d_gui_input(camera, event):
	#general blocker of all logic, comes in handy for sure
	if ProbuilderVars.block:
		return

	#generic method to set mouseposition
	if event is InputEventMouseMotion:
		set_mouse_position(camera,event.position)
		
	#raycast action
	if event is InputEventMouseButton and event.pressed and event.button_index== 1:
		
		customRayCast(camera,event.position,event )
		
	
	# 3Step logic. first to set position then set scale on x and z and then the last click will modify the height/y value
	
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		if firstEvent == null:
			firstEvent=event
			ProbuilderVars.instantiated_obj=ProbuilderVars.objs[ProbuilderVars.selected_index].instantiate()
			var Owner=collisionParent.get_parent()
			Owner.add_child(ProbuilderVars.instantiated_obj)
			
			#code to set instantiated obj as persistent
			ProbuilderVars.instantiated_obj.owner=Owner
			ProbuilderVars.instantiated_obj.set_owner(Owner)
		
		
			#little thing
			
			ProbuilderVars.instantiated_obj.position=collisionPosition
			#print("first click")
		
		#To make the script less heavy, u can change the secondevent to a boolean and not an event!
		elif secondEvent == null  and firstEvent:
			secondEvent=event
			
		elif thirdEvent ==null and secondEvent and firstEvent:
			thirdEvent=event
			firstEvent = null
			secondEvent= null
			thirdEvent=null
		#	print("second click")
	
	#if it's on the second step, gradually modify the scale!
	if firstEvent and secondEvent==null and event is InputEventMouseMotion:
		#print((event.position-firstEvent.position))
		var temp=(event.position-firstEvent.position).abs()
		ProbuilderVars.instantiated_obj.scale=Vector3(temp.x,1,temp.y)
	
	
	#if it's on the third step, gradually modify the height!
	if firstEvent and secondEvent and thirdEvent ==null and event is InputEventMouseMotion:
		#print((event.position-firstEvent.position))
		var scalingfactor=(event.position-firstEvent.position).length()*ProbuilderVars.scaling_factor_factor
		if (event.position-firstEvent.position).length()<0.2:
			ProbuilderVars.instantiated_obj.scale.y=0.2
		else:
			ProbuilderVars.instantiated_obj.scale.y=scalingfactor
	
		#generic scaling on all 3 Axis Maybe custom option?
#		var scalingfactor=(event.position-firstEvent.position).length()*ProbuilderVars.scaling_factor_factor
#		if (event.position-firstEvent.position).length()*ProbuilderVars.scaling_factor_factor<0.2:
#			ProbuilderVars.instantiated_obj.scale=Vector3(0.2,0.2,0.2)
#		else:
#			ProbuilderVars.instantiated_obj.scale=Vector3(scalingfactor,scalingfactor,scalingfactor)
			
	
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
			collisionPosition=collision.position
			
	else:# no RaycastHit
		ProbuilderVars.label_text="no raycasthit!"
		pass



	

#recursive function to print the fucking tree
func printChildNodeNames(node,indent="-"):
	for child in node.get_children():
		print(indent,child.name)
		# Recursively call the function for children of the current child
		printChildNodeNames(child,indent+"-")
	

