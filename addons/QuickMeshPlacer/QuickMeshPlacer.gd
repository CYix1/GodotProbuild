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

	
func _enter_tree():
	#loading the scene with the dock and setup dock and plugin
	state=0

	object_window= preload("res://addons/QuickMeshPlacer/object_window.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL,object_window)
	add_custom_type("Pref_Btn","Button",preload("res://addons/QuickMeshPlacer/prefButton.gd"),preload("res://icon.svg"))
	
func _exit_tree():
	#freeing shit
	remove_control_from_docks(object_window)
	object_window.free()
	remove_custom_type("pref_Btn")
	
func _process(delta):

	
	if 	get_editor_interface().get_selection().get_selected_nodes().is_empty():
		var Owner=get_editor_interface().get_edited_scene_root()
		
		get_editor_interface().get_selection().add_node(Owner)

#need to return true, so _forward_3d_gui_input is called!
func _handles(object):
	return true
			
#random Variables for logic
#GET THE FUCKING MOUSEPOSITION GOD DAMMIT
func _forward_3d_gui_input(camera, event):
	
	if event is InputEventKey:
		handle_key_input(event)

	#general blocker of all logic, comes in handy for sure
	if ProbuilderVars.block.data:
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
			first_click_position=getRaycastHitCollision(camera,event.position).position
			spawn_prefab()
		#To make the script less heavy, u can change the secondevent to a boolean and not an event!
		elif state==1:
			state=2
			ProbuilderVars.state_text="currentState: scale Object 2"
			#skip one click since no height change needed
			if ProbuilderVars.all_axis_scale.data:
				
				finish_placing()
#			
				
		elif state==2:
			finish_placing()
#			
		#	print("second click")
	
	if state==0:
		ProbuilderVars.state_text="currentState: ready to place"
	#if it's on the second step, gradually modify the scale!
	if state==1 and event is InputEventMouseMotion:
		
		if ProbuilderVars.all_axis_scale.data:
			#limiting the scalingfactor to a min or 
			var scalingfactor=(getRaycastHitCollision(camera,event.position).position-first_click_position).length()*ProbuilderVars.scaling_factor_factor
			var scale_value=max(0.2,scalingfactor)
			ProbuilderVars.instantiated_obj.scale=Vector3(scale_value,scale_value,scale_value)
			
			#if (event.position-first_click_position).length()<0.2:
			#	ProbuilderVars.instantiated_obj.scale=Vector3(0.2,0.2,0.2)
			#else:
			#	ProbuilderVars.instantiated_obj.scale=Vector3(scalingfactor,scalingfactor,scalingfactor)
		
		else:
			#print((event.position-firstEvent.position))
			var temp=(getRaycastHitCollision(camera,event.position).position-first_click_position).abs()*ProbuilderVars.scaling_factor_factor.data
			var m=Vector3(temp.x,min(temp.x,temp.z),temp.z)
		
			ProbuilderVars.instantiated_obj.scale=Vector_max(Vector3.ONE,m).abs()	
		#if "snapping" round scale!
		if ProbuilderVars.snap_objects:
			ProbuilderVars.instantiated_obj.scale=ProbuilderVars.instantiated_obj.scale.snapped(ProbuilderVars.snapping_value.data)
	
#if it's on the third step, gradually modify the height!
	if state==2 and event is InputEventMouseMotion:
			
		#print((event.position-firstEvent.position))
		var scalingfactor=(getRaycastHitCollision(camera,event.position).position-first_click_position).length()*ProbuilderVars.scaling_factor_factor.data
		var scale_value=max(0.2,scalingfactor)
		ProbuilderVars.instantiated_obj.scale.y=scale_value
		if ProbuilderVars.snap_objects.data:
			ProbuilderVars.instantiated_obj.scale=ProbuilderVars.instantiated_obj.scale.snapped(ProbuilderVars.snapping_value.data)
		#generic scaling on all 3 Axis Maybe custom option?
		
func Vector_max(min:Vector3, value:Vector3):
	var x=max(min.x,value.x)
	var y=max(min.y,value.y)
	var z=max(min.z,value.z)
	return Vector3(x,y,z)

func finish_placing():
	#ProbuilderVars.block.data=true
	state=0

	if ProbuilderVars.height_fix_after_placement.data:
		
		var offset=ProbuilderVars.instantiated_obj.scale.y/2
		ProbuilderVars.instantiated_obj.position.y=ProbuilderVars.instantiated_obj.position.y+offset	
	print("finish")
		
func spawn_prefab():
	ProbuilderVars.instantiated_obj=ProbuilderVars.objs[ProbuilderVars.selected_index].instantiate()
	var Owner=collisionParent
	while Owner.name != "Main":
		Owner=Owner.get_parent()
	Owner.add_child(ProbuilderVars.instantiated_obj)
	
	ProbuilderVars.instantiated_obj.name= "block"
	
	#code to set instantiated obj as persistent
	ProbuilderVars.instantiated_obj.owner=Owner
	ProbuilderVars.instantiated_obj.set_owner(Owner)
	ProbuilderVars.instantiated_obj.position=collisionPosition
	print(collisionPosition)
	if ProbuilderVars.randomXZ.data:
		
		ProbuilderVars.instantiated_obj.global_rotation_degrees=randomVector(0.0,360.0,false,true,false)

		if ProbuilderVars.randomScaleMax.data:
			ProbuilderVars.instantiated_obj.scale=randomVector(1.0,ProbuilderVars.randomScaleMax.data,true,true,true)
		finish_placing()

	if ProbuilderVars.snap_objects.data:
		collisionPosition=collisionPosition.snapped(ProbuilderVars.snapping_value.data)
		ProbuilderVars.instantiated_obj.position=ProbuilderVars.instantiated_obj.position.snapped(ProbuilderVars.snapping_value.data)


	
	
	
func randomVector(minValue: float, maxValue:float, changeX:bool, changeY: bool, changeZ:bool)-> Vector3:
	var rng = RandomNumberGenerator.new()
	var ret= Vector3.ZERO
	if changeX:
		ret.x= rng.randf_range(minValue,maxValue)
	if changeY:
		ret.y= rng.randf_range(minValue,maxValue)
	if changeZ:
		ret.z= rng.randf_range(minValue,maxValue)
	
	return ret	

func randomVector3(minValue: Vector3, maxValue:Vector3, changeX:bool, changeY: bool, changeZ:bool)-> Vector3:
	var rng = RandomNumberGenerator.new()
	var ret= Vector3.ZERO
	if changeX:
		ret.x= rng.randf_range(minValue.x,maxValue.x)
	if changeY:
		ret.y= rng.randf_range(minValue.y,maxValue.y)
	if changeZ:
		ret.z= rng.randf_range(minValue.z,maxValue.z)
	print(ret)
	return ret	

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

#basic raycast to get the collision
func getRaycastHitCollision(camera: Camera3D, screen_pos:Vector2):
	
	var ray_start = camera.project_ray_origin(screen_pos)
	var ray_end = ray_start + camera.project_ray_normal(screen_pos) * 50000
	var space = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_start,ray_end)
	var collision=space.intersect_ray(query)
	assert(collision,"NO COLLISION WTF U DOING")
	return collision
	
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

		#Set variables
		if ProbuilderVars.raycast_ground.data:

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

