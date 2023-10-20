@tool
extends Control


var lbl_txt=ProbuilderVars.label_text

func _process(delta):
	$VBoxContainer/Label.text = lbl_txt
	$VBoxContainer/Mode.text = "Index: %d " % [ ProbuilderVars.selected_index] 
	$VBoxContainer/Label2.text= "Current Object:  %s " % ProbuilderVars.objs[ProbuilderVars.selected_index].resource_name
	
func _on_cube_btn_pressed():
	ProbuilderVars.selected_index=0
	ProbuilderVars.objs[ProbuilderVars.selected_index].resource_name

func _on_sphere_btn_pressed():
	lbl_txt="Sphere"
	ProbuilderVars.selected_index=1


func _on_capsule_btn_pressed():
	lbl_txt="Capsule"
	ProbuilderVars.selected_index=2


func _on_cylinder_btn_pressed():
	lbl_txt="Cylinder"
	ProbuilderVars.selected_index=3


func _on_plane_btn_pressed():
	lbl_txt="Plane"
	ProbuilderVars.selected_index=4


func _on_circle_btn_pressed():
	lbl_txt="Circle"
	ProbuilderVars.selected_index=5


func _on_reset_values_btn_pressed():
	ProbuilderVars.mode=0
	ProbuilderVars.selected_index=0


func _on_h_slider_value_changed(value):
	$VBoxContainer/Label3.text=str(value)
	ProbuilderVars.scaling_factor_factor=value


func _on_check_box_pressed():
	ProbuilderVars.block=!ProbuilderVars.block
	print(ProbuilderVars.block)
