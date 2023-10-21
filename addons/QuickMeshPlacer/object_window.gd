@tool
extends Control


func _ready():
	#Events
	ProbuilderVars.on_block.connect(_on_block_change)
	ProbuilderVars.on_snap_objects.connect(_on_snap_change)
	ProbuilderVars.on_all_axis_scale.connect(_on_all_axis_change)
	ProbuilderVars.on_raycast_ground.connect(_on_raycast_ground_change)
	
	#list of all scenes in Prefabs
	print(list_files_in_directory("res://Prefabs/"))
	var counter=0
	#clear all buttons
	for child in $VBoxContainer/Buttons.get_children():
		child.free()
	
	#instantiate new buttons and set counter!
	# counter is needed for the probuilder logic!
	for prefab in list_files_in_directory("res://Prefabs/"):
		var btn= PrefButton.new()
		btn.index=counter
		btn.text=prefab
		$VBoxContainer/Buttons.add_child(btn)
		counter+=1

#continous changing of some labels... should be events
func _process(delta):
	$VBoxContainer/Label.text = ProbuilderVars.label_text
	#$VBoxContainer/Mode.text = "Tool Blocked? %s " % [ ProbuilderVars.block] 
	$VBoxContainer/Label2.text= "Current Object:  %s " % str(ProbuilderVars.objs[ProbuilderVars.selected_index].resource_name)
	


func list_files_in_directory(path):
	var files = []
	var dir = DirAccess.open(path)

	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with("tscn"):
			
			files.append(file)

	dir.list_dir_end()

	return files
	
func _on_block_change(value):
	$VBoxContainer/BlockCheckBtn.button_pressed=value
	
func _on_snap_change(value):
	$VBoxContainer/SnapCheckBtn.button_pressed=value
	
func _on_all_axis_change(value):
	$VBoxContainer/AllAxisScale.button_pressed=value
	
func _on_raycast_ground_change(value):
	$VBoxContainer/RayCastGroundBtn.button_pressed=value
	
func _on_reset_values_btn_pressed():
	ProbuilderVars.selected_index=0


func _on_h_slider_value_changed(value):
	$VBoxContainer/Label3.text=str(value)
	ProbuilderVars.scaling_factor_factor=value


func _on_check_button_toggled(button_pressed):
	ProbuilderVars.block=button_pressed


func _on_snap_check_btn_toggled(button_pressed):
	ProbuilderVars.snap_objects=button_pressed



func _on_all_axis_scale_toggled(button_pressed):
	ProbuilderVars.all_axis_scale=button_pressed


func _on_ray_cast_ground_btn_toggled(button_pressed):
	ProbuilderVars.raycast_ground=button_pressed
	
