@tool
extends MeshInstance3D

@export var points:Array=[]

func addLine(p1:Vector3 , p2:Vector3):
	points.append(p1)
	points.append(p2)

func _ready():
	points.clear()
func _process(delta):
	draw()
	
func draw():
	return
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	

		
	mesh.surface_end()

func Clear():
	points.clear()
