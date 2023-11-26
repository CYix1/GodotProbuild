@tool
extends Control


func _ready():
	#Events
	
	
	ProbuilderVars.block.on_value_change.connect(_on_block_change)
	ProbuilderVars.snap_objects.on_value_change.connect(_on_snap_change)
	ProbuilderVars.all_axis_scale.on_value_change.connect(_on_all_axis_change)
	ProbuilderVars.raycast_ground.on_value_change.connect(_on_raycast_ground_change)	
	ProbuilderVars.randomXZ.on_value_change.connect(_on_randomXZ_change)	
	ProbuilderVars.height_fix_after_placement.on_value_change.connect(_on_height_fix_btn_change)
	set_all_autoload_vars()
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
	$VBoxContainer/Mode.text = "Tool Blocked? %s " % [ str(ProbuilderVars.block.data)] 
	$VBoxContainer/Label2.text= ProbuilderVars.state_text
	


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


func _on_reset_values_btn_pressed():
	ProbuilderVars.print_state()
	set_all_autoload_vars()

func set_all_autoload_vars():
	$VBoxContainer/Label.text = ProbuilderVars.label_text
	$VBoxContainer/Label2.text=ProbuilderVars.state_text
	
	$VBoxContainer/Mode.text = "Tool Blocked?" + str(ProbuilderVars.block.data) 
	$VBoxContainer/BlockCheckBtn.button_pressed=ProbuilderVars.block.data
	
	$VBoxContainer/SnapCheckBtn.button_pressed=ProbuilderVars.snap_objects.data
	$VBoxContainer/AllAxisScaleBtn.button_pressed=ProbuilderVars.all_axis_scale.data
	$VBoxContainer/RayCastBtn.button_pressed=ProbuilderVars.raycast_ground.data
	$VBoxContainer/FixHeightBtn.button_pressed=ProbuilderVars.height_fix_after_placement.data
	$VBoxContainer/RandomPlcBtn.button_pressed=ProbuilderVars.randomXZ.data
	
	$VBoxContainer/Label3.text="scaling speed: "+str(ProbuilderVars.scaling_factor_factor.data)
	$VBoxContainer/Label4.text="snap value: "+str(ProbuilderVars.snapping_value.data)
	var t=ProbuilderVars.randomScaleMax.data
	$VBoxContainer/Label5.text="scaling max: "+str(Vector3(t,t,t))
	

	
func _on_block_change(value):
	$VBoxContainer/BlockCheckBtn.button_pressed=value
	
func _on_snap_change(value):
	$VBoxContainer/SnapCheckBtn.button_pressed=value
	
func _on_all_axis_change(value):
	$VBoxContainer/AllAxisScaleBtn.button_pressed=value
	
func _on_raycast_ground_change(value):
	$VBoxContainer/RayCastBtn.button_pressed=value

func _on_height_fix_btn_change(value):
	$VBoxContainer/FixHeightBtn.button_pressed=value
	
func _on_randomXZ_change(value):
	$VBoxContainer/RandomPlcBtn.button_pressed=value


func _on_check_button_toggled(button_pressed):
	ProbuilderVars.block.data=button_pressed

func _on_snap_check_btn_toggled(button_pressed):
	ProbuilderVars.snap_objects.data=button_pressed

func _on_height_fix_btn_toggled(button_pressed):
	ProbuilderVars.height_fix_after_placement.data=button_pressed


func _on_all_axis_scale_toggled(button_pressed):
	ProbuilderVars.all_axis_scale.data=button_pressed

func _on_ray_cast_ground_btn_toggled(button_pressed):
	ProbuilderVars.raycast_ground.data=button_pressed


func _on_random_plc_btn_toggled(button_pressed):
	ProbuilderVars.randomXZ.data=button_pressed


	
	
func _on_h_slider_value_changed(value):
	$VBoxContainer/Label3.text="scaling speed: %.3f" % float(value)
	ProbuilderVars.scaling_factor_factor.data=value


func _on_h_slider_2_value_changed(value):
	ProbuilderVars.snapping_value.data=Vector3(value,value,value)
	$VBoxContainer/Label4.text="snap value: "+str(ProbuilderVars.snapping_value.data)

func _on_random_scale_btn_value_changed(value:float):
	
	ProbuilderVars.randomScaleMax.data=value
	$VBoxContainer/Label5.text="scaling max: "+str(ProbuilderVars.randomScaleMax.data)
