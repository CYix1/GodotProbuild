@tool
extends CSGCombiner3D

@export var amount=1

var base_prefab : CSGCombiner3D
var childs_parent



@export var startGenerator: bool = false : set = set_button2
func set_button2(new_value: bool) -> void:
	#generate()
	FixBuildType()
	pass 
enum BuildTypeEnum {Roof, Base, Mid,NOTeleport}
@export var options=0	
@export var buildType =BuildTypeEnum.Mid
func _ready():
	
	FixBuildType()

func FixBuildType():
	if buildType== BuildTypeEnum.Roof and $StairUp:
		$StairUp.queue_free()
	if buildType== BuildTypeEnum.Base and $StairDown:
		$StairDown.queue_free()
	if buildType== BuildTypeEnum.NOTeleport and $StairUp and $StairDown :
		$StairDown.queue_free()
		$StairUp.queue_free()
	if options==0:
		$"Walls/Ground/option 2".queue_free()
		
		$"Walls/Ground/option 1".visible=true
	if options==1:
		$"Walls/Ground/option 1".queue_free()
		
		$"Walls/Ground/option 2".visible=true
		
func generate():
	for i in amount-1:
		var child=base_prefab.duplicate(DUPLICATE_USE_INSTANTIATION)
		var owner= get_node(".")
		spawnChild(child,owner)
		child.global_position=Vector3(0,15*(i+1),0)

	

func spawnChild(child, Owner):
	Owner.add_child(child)

	#code to set instantiated obj as persistent
	child.owner=Owner
	child.set_owner(Owner)
	child.name="duplication"
