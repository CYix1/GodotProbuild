@tool
extends Node3D

enum COLLECTABLE_TYPE {TELEPORTER, INTERACT,KEY_COLLECT,KEY_GUARD, EXIT_TEL}
@export var collider_size = Vector3.ONE 
@export var teleport_position = Vector3.ONE
@export var teleport_relative = false
@export var teleportPoint: NodePath
@export var label_rotation = Vector3.ONE
@export var collectable_string = ""
@export var label_offset=Vector3.UP
@export var editor=false
@export var label_visibility=false
@export var collectable_type= COLLECTABLE_TYPE.TELEPORTER
@export var interact_objs:Array[NodePath]  =[] 

var check_input=false
var active=true


func _ready():
	set_params()
func set_params():
	$StartPoint.global_position=global_position

	$StartPoint/CollisionShape3D.scale=collider_size
	
	$TeleportPos.global_position=teleport_position
	
	$Label3D.global_position=global_position+label_offset
	$Label3D.text=collectable_string
	$Label3D.global_rotation_degrees=label_rotation	
	$Label3D.visible=label_visibility


func _process(delta):
	if editor:
		set_params()

	if !active:
		return
	if !check_input:
		return
	if Input.is_key_pressed(KEY_E) :
		$Label3D.visible=false
		active=false
		print("kill")
		if collectable_type==COLLECTABLE_TYPE.KEY_COLLECT:
			GameState.amount_keys+=1
	
		if collectable_type== COLLECTABLE_TYPE.KEY_GUARD:
			GameState.amount_keys-=1
			if GameState.amount_keys<0:
				print("dawfe")
				$Label3D.text="NO KEY, Go to the colored tower to collect"
				$Label3D.visible=true
				return
			
		if interact_objs != null:
			for objs in interact_objs:
				get_node(objs).queue_free()
		self.queue_free()
		
		

func _on_start_point_body_entered(body: Node3D):
	if "Player" in body.name:
		handle_player_interact(body)
	
	

func handle_player_interact(body: Node3D):
	
	if collectable_type == COLLECTABLE_TYPE.TELEPORTER:
		if teleportPoint==null:
			if teleport_relative:
				body.global_position+=teleport_position
			else:
				body.global_position=$TeleportPos.global_position
		else:
			body.global_position=get_node(teleportPoint).global_position
	elif collectable_type == COLLECTABLE_TYPE.EXIT_TEL:
		if GameState.amount_keys==0:
			body.global_position=$TeleportPos.global_position
		else:
			$Label3D.text="Save the people first!"
	elif collectable_type== COLLECTABLE_TYPE.INTERACT or collectable_type==COLLECTABLE_TYPE.KEY_COLLECT:
		$Label3D.visible=true
		check_input=true
	elif collectable_type ==COLLECTABLE_TYPE.KEY_GUARD:
		$Label3D.visible=true
		check_input=true
	



func _on_start_point_body_exited(body):
	if "Player" in body.name:
		$Label3D.visible=false
	
