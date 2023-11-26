@tool
extends StaticBody3D

@export_range(1,50,0.1) var size :float  
@export var ruler_width=0.1
@export var label_size=0.013
@export var label_offset=Vector3(-0.25,0.5,0.0)
@export var other_side=false
@export var text_billboard=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$CSGPolygon3D.polygon[2].x=ruler_width
	$CSGPolygon3D.polygon[3].x=ruler_width
	$CSGPolygon3D.set_scale(Vector3(1,size,1))
	
	if text_billboard:
		$Label3D.billboard=1
	else:		
		$Label3D.billboard=0
	$Label3D.pixel_size=label_size	
	
	$Label3D.set_scale(Vector3(size,size,size))
	if !other_side:
		$Label3D.position=Vector3(-0.25*size,0.5*size,0)
		$Label3D.rotation_degrees=Vector3(0,0,90)
	else: 
		$Label3D.position=Vector3(0.25*size,0.5*size,0)
		$Label3D.rotation_degrees=Vector3(0,0,-90)
	$Label3D.text=""+str(size)+"M"
	$Label3D.position=label_offset
