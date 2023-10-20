@tool
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("=======a")
	var space = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(Vector3(0,10,0),
			Vector3(0,-10,0))
	query.collide_with_areas=true
	
	print("daw",query.from,query.to, query.collide_with_areas,query.collide_with_bodies)
	print(space)
	var collision = space.intersect_ray(query)
	
	print(collision)
	if collision:
		print(collision.collider.name)
	else:
		print("no raycasthit!")
	
	print("=======b")
