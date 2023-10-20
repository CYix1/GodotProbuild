@tool
extends Control


var lbl_txt=ProbuilderVars.label_text
func _process(delta):

	$VBoxContainer/Label.text = ProbuilderVars.label_text
	$VBoxContainer/Mode.text = "Mode: %d | index: %d " % [ProbuilderVars.mode, ProbuilderVars.selected_index] 
	
	
func _on_button_pressed():
	lbl_txt="Cube"
	ProbuilderVars.selected_index=0
	print("hi")


func _on_button_2_pressed():
	lbl_txt="Sphere"

	ProbuilderVars.selected_index=1
	print("hi2")


func _on_button_3_pressed():
	lbl_txt="Capsule"

	ProbuilderVars.selected_index=2
	print("hi23")


func _on_button_4_pressed():
	lbl_txt="KMS"
	ProbuilderVars.selected_index=3
	print("UwU")

func _on_button_5_pressed():
	
	ProbuilderVars.mode=0	
	pass # Replace with function body.

#save the scene
func _on_button_6_pressed():
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().current_scene)
	ResourceSaver.save( packed_scene,"res://Test.tscn",ResourceSaver.FLAG_NONE)
	


func _on_button_7_pressed():
	ProbuilderVars.goto_scene("res://Probuilder.tscn")
