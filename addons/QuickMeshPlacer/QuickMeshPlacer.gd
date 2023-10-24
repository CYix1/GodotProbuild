@tool
extends EditorPlugin

#the Editowindow, which is shown in the dock left!
var object_window
var collisionParent=null
var collisionPosition=null
var state=0
var first_click_position=Vector3()
'''TODO:
snapping with Vector3.snapped and not round?
'''

func test(value):
	print(value)
	
func _enter_tree():
	#loading the scene with the dock and setup dock and plugin
	state=0
	ProbuilderVars.height_fix_after_placement.on_value_change.connect(test)
	object_window= preload("res://addons/QuickMeshPlacer/object_window.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL,object_window)
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
#GET THE FUCKING MOUSEPOSITION GOD DAMMIT
func _forward_3d_gui_input(camera, event):
	
	if event is InputEventKey:
		handle_key_input(event)

	#general blocker of all logic, comes in handy for sure
	if ProbuilderVars.block:
		return

	#generic method to set mouseposition
	if event is InputEventMouseMotion:
		set_mouse_position(camera,event.position)
		
	#raycast action
	if event is InputEventMouseButton and event.pressed and event.button_index== 1:
		customRayCast(camera,event.position,event )
	
	if state==0 and collisionParent == null:
		return
	
	# 3Step logic. first to set position then set scale on x and z and then the last click will modify the height/y value
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		if state==0:
			state=1
			ProbuilderVars.state_text="currentState: scale Object 1"
			first_click_position=event.position
			spawn_prefab()
		#To make the script less heavy, u can change the secondevent to a boolean and not an event!
		elif state==1:
			state=2
			ProbuilderVars.state_text="currentState: scale Object 2"
			#skip one click since no height change needed
			if ProbuilderVars.all_axis_scale:
				
				finish_placing()
#				var offset=ProbuilderVars.instantiated_obj.scale.y/2
#				ProbuilderVars.instantiated_obj.position.y=ProbuilderVars.instantiated_obj.position.y+offset	
	
				
		elif state==2:
			finish_placing()
#			var offset=ProbuilderVars.instantiated_obj.scale.y/2
#			ProbuilderVars.instantiated_obj.position.y=ProbuilderVars.instantiated_obj.position.y+offset	

		#	print("second click")
	
	if state==0:
		ProbuilderVars.state_text="currentState: ready to place"
	#if it's on the second step, gradually modify the scale!
	if state==1 and event is InputEventMouseMotion:
		
		if ProbuilderVars.all_axis_scale:
			#limiting the scalingfactor to a min or 
			var scalingfactor=(event.position-first_click_position).length()*ProbuilderVars.scaling_factor_factor
			var scale_value=max(0.2,scalingfactor)
			ProbuilderVars.instantiated_obj.scale=Vector3(scale_value,scale_value,scale_value)
			
			#if (event.position-first_click_position).length()<0.2:
			#	ProbuilderVars.instantiated_obj.scale=Vector3(0.2,0.2,0.2)
			#else:
			#	ProbuilderVars.instantiated_obj.scale=Vector3(scalingfactor,scalingfactor,scalingfactor)
		
		else:
			#print((event.position-firstEvent.position))
			var temp=(event.position-first_click_position).abs()
			ProbuilderVars.instantiated_obj.scale=Vector3(temp.x,1,temp.y)
			
		#if "snapping" round scale!
		if ProbuilderVars.snap_objects:
			print(ProbuilderVars.instantiated_obj.scale)
			print(ProbuilderVars.instantiated_obj.scale.snapped(ProbuilderVars.snapping_value))
			ProbuilderVars.instantiated_obj.scale=ProbuilderVars.instantiated_obj.scale.snapped(ProbuilderVars.snapping_value)
	
#if it's on the third step, gradually modify the height!
	if state==2 and event is InputEventMouseMotion:
			
		#print((event.position-firstEvent.position))
		var scalingfactor=(event.position-first_click_position).length()*ProbuilderVars.scaling_factor_factor
		var scale_value=max(0.2,scalingfactor)
		ProbuilderVars.instantiated_obj.scale.y=scale_value
		if ProbuilderVars.snap_objects:
			ProbuilderVars.instantiated_obj.scale=ProbuilderVars.instantiated_obj.scale.snapped(ProbuilderVars.snapping_value)
		#generic scaling on all 3 Axis Maybe custom option?
	
func finish_placing():
	
	state=0
	print(ProbuilderVars.height_fix_after_placement.data)
	if ProbuilderVars.height_fix_after_placement.data:
		print("daw")
		var offset=ProbuilderVars.instantiated_obj.scale.y/2
		ProbuilderVars.instantiated_obj.position.y=ProbuilderVars.instantiated_obj.position.y+offset	

		
func spawn_prefab():
	ProbuilderVars.instantiated_obj=ProbuilderVars.objs[ProbuilderVars.selected_index].instantiate()
	var Owner=collisionParent.get_parent()
	Owner.add_child(ProbuilderVars.instantiated_obj)
	ProbuilderVars.instantiated_obj.name= "block"
	
	#code to set instantiated obj as persistent
	ProbuilderVars.instantiated_obj.owner=Owner
	ProbuilderVars.instantiated_obj.set_owner(Owner)
	ProbuilderVars.instantiated_obj.position=collisionPosition
	
	if ProbuilderVars.snap_objects:
		collisionPosition=collisionPosition.snapped(ProbuilderVars.snapping_value)
		ProbuilderVars.instantiated_obj.position=ProbuilderVars.instantiated_obj.position.snapped(ProbuilderVars.snapping_value)
		
func handle_key_input(event):
	pass
	#if event.keycode==KEY_CTRL:
	#	ProbuilderVars.block=!ProbuilderVars.block
	
	#if event.keycode==KEY_SHIFT:
	#	ProbuilderVars.snap_objects=!ProbuilderVars.snap_objects	
		
	#if event.keycode==KEY_TAB:
	#	ProbuilderVars.all_axis_scale=!ProbuilderVars.all_axis_scale
	

	
#set 2d/3D mouse position
func set_mouse_position(camera,pos):
	ProbuilderVars.mouse_position= pos
	ProbuilderVars.position_3D= camera.project_position(ProbuilderVars.mouse_position,ProbuilderVars.z_depth)


#Raycasting from camera to mouse 3d Position!
func customRayCast(camera :Camera3D, pos:Vector2,event ):
	collisionParent=null
	ProbuilderVars.mouse_position= pos
	
	var ray_start = camera.project_ray_origin(pos)
	var ray_end = ray_start + camera.project_ray_normal(pos) * 50000
	ProbuilderVars.p1=ray_start
	ProbuilderVars.p2=ray_end
	
	#Raycast specific things
	var space = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_start,
			 ray_end)
	query.collide_with_areas=true
	var collision = space.intersect_ray(query)
	
	if collision: # RaycastHit
		print(collision.position)	
		#Set variables
		if ProbuilderVars.raycast_ground:
			if collision.collider.name == "Ground":
				collisionParent=collision.collider
				collisionPosition=collision.position
				ProbuilderVars.label_text=collision.collider.name
			else:
				collisionPosition=Vector3(0,0,0)
				ProbuilderVars.label_text="RANDOM POSITION POSSIBLE"
		else: 
			collisionParent=collision.collider
			collisionPosition=collision.position
		
			ProbuilderVars.label_text=collision.collider.name
			
	else:# no RaycastHit
		ProbuilderVars.label_text="no raycasthit!"

