extends CharacterBody2D
class_name npc_frogge

@export var default_move_speed: float = 20.0
@export var move_speed: float = 40.0
@export var wander_radius: float = 60.0

@onready var animation_tree = $AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var flee_body: CharacterBody2D = null
var target: Vector2
var home_position: Vector2

@export var skins: Array[Texture2D] = []

func _ready():
	home_position = global_position
	if skins.size() > 0:
		sprite.texture = skins[randi() % skins.size()]
	
	#$StateChart/Root/Wander.delay_in_seconds = randi_range(5, 10)
		


func _physics_process(_delta):

	var next = nav_agent.get_next_path_position()
	velocity = (next - global_position).normalized() * move_speed

	if not nav_agent.is_navigation_finished():
		if velocity.x < 0.0:
			sprite.flip_h = true
		elif velocity.x >= 0:
			sprite.flip_h = false
	else:
		sprite.flip_h = false
		velocity = Vector2.ZERO
	move_and_slide()
	
		
func is_good_position(pos: Vector2) -> bool:
	return pos.distance_to(home_position) <= wander_radius


func _on_run_state_entered() -> void:

	_go_to(target)
	
	
func _on_surprise_area_body_entered(body: Node2D) -> void:
	if body is player_frogge:
		$StateChart.send_event("character_nearby")


func _on_surpise_state_entered() -> void:
	state_machine.travel("surprise")


func _on_run_area_body_entered(body: Node2D) -> void:
	if body is player_frogge:
		flee_body = body
		$StateChart.send_event("character_too_close")


func _on_idle_state_entered() -> void:
	state_machine.travel("idle%d" % randi_range(1,3))
	velocity = Vector2.ZERO


func _on_wander_state_entered() -> void:
	#target = Vector2(global_position.x + randf_range(-50, 50), global_position.y + randf_range(-50, 50))
	target = _get_navigable(Vector2(global_position.x + randf_range(-20, 20), global_position.y + randf_range(-20, 20)))
	_go_to(target)

func _get_navigable(pos: Vector2) -> Vector2:
	return NavigationServer2D.map_get_closest_point(get_world_2d().navigation_map, pos)

func _go_to(pos: Vector2) -> void:
	nav_agent.target_position = pos
	state_machine.travel("run")

func _on_surprise_area_body_exited(body: Node2D) -> void:
	if body is player_frogge:

		$StateChart.send_event("character_left")


func _on_navigation_agent_2d_navigation_finished() -> void:
	$StateChart.send_event("nav_finished")


func _on_flee_state_entered() -> void:
	var flee_dir: Vector2 = (global_position - flee_body.global_position)
	target = _get_navigable(global_position + flee_dir * 2)
