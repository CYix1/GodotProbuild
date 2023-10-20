@tool
extends Control


var lbl_txt=ProbuilderVars.label_text
func _ready():
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
	$VBoxContainer/Label.text = lbl_txt
	$VBoxContainer/Mode.text = "Index: %d " % [ ProbuilderVars.selected_index] 
	$VBoxContainer/Label2.text= "Current Object:  %s " % ProbuilderVars.objs[ProbuilderVars.selected_index].resource_name
	

func list_files_in_directory(path):
	var files = []
	var dir = DirAccess.open(path)

	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
	


func _on_reset_values_btn_pressed():
	ProbuilderVars.selected_index=0
	#TODO other Reset things?


func _on_h_slider_value_changed(value):
	$VBoxContainer/Label3.text=str(value)
	ProbuilderVars.scaling_factor_factor=value


func _on_check_box_pressed():
	ProbuilderVars.block=!ProbuilderVars.block
	print(ProbuilderVars.block)
