@tool
extends Control


var lbl_txt=ProbuilderVars.label_text
var names=["Cube","Sphere","Capsule","Cylinder","Plane","Circle"]
func _process(delta):

	$VBoxContainer/Label.text = lbl_txt
	$VBoxContainer/Mode.text = "Mode: %d | index: %d " % [ProbuilderVars.mode, ProbuilderVars.selected_index] 

	$VBoxContainer/Label2.text= "Current Object:  %s " % names[ProbuilderVars.selected_index]

func _on_cube_btn_pressed():
	lbl_txt="Cube"
	ProbuilderVars.selected_index=0
	

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
