extends CSGCombiner3D

var old_walk_speed=0
var old_run_speed=0
@export var new_walk_speed=15
@export var new_run_speed=20
func _on_static_body_3d_body_entered(body:Node3D):
	
	if "Player" in body.name:
		var playerScript=body
		old_walk_speed=playerScript.walk_speed
		old_run_speed=playerScript.run_speed
		
		playerScript.walk_speed=new_walk_speed
		playerScript.run_speed=new_run_speed
		

func _on_static_body_3d_body_exited(body:Node3D):
	if "Player" in body.name:
		var playerScript=body
		playerScript.walk_speed=old_walk_speed
		playerScript.run_speed=old_run_speed

