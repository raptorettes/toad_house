extends CharacterBody2D
class_name player_frogge

@export var move_speed: float = 70
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var anim_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var input_direction: Vector2 = Vector2.ZERO
var current_state: String = ""

#Non-Generic
#For water SFX
#var water_layer: TileMapLayer
#@onready var water_audio = $WaterFX

#func _ready():
	#detect if on water for sfx
	#water_layer = get_tree().get_first_node_in_group("water")




func _physics_process(_delta):
	input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if input_direction.x < 0:
		sprite.flip_h = true
	elif input_direction.x > 0:
		sprite.flip_h = false
	
	velocity = input_direction * move_speed
	move_and_slide()
	pick_new_state()
	#check_water()
	
	

func flip_sprite():
	if abs(input_direction.x) > 0.7:
		scale.x = -1 if input_direction.x < 0 else 1

func pick_new_state():
	var new_state = "run" if input_direction != Vector2.ZERO else "idle1"
	if new_state != current_state:
		current_state = new_state
		state_machine.travel(new_state)
		
		
#NON GENERIC
#WaterFX
#func check_water() -> void:
	#if not water_layer:
		#return
	#var tile_pos = water_layer.local_to_map(water_layer.to_local(global_position))
	#var tile_data = water_layer.get_cell_tile_data(tile_pos)
	#if tile_data != null and input_direction != Vector2.ZERO:
		#if not water_audio.playing:
			#water_audio.play()
	#else:
		#water_audio.stop()
		
		
