extends CharacterBody2D
class_name npc_frogge

@export var default_move_speed: float = 20.0
@export var move_speed: float = 40.0
@export var wander_radius: float = 60.0

@onready var animation_tree = $AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D

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
	if velocity != Vector2.ZERO:
		
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
		
		move_and_slide()
		
func is_good_position(pos: Vector2) -> bool:
	return pos.distance_to(home_position) <= wander_radius


func _on_run_state_entered() -> void:
	
	var flee_dir: Vector2 = (global_position - flee_body.global_position)
	target = global_position + flee_dir * 20

	_go_to(target)
	
	
func _on_surprise_area_body_entered(body: Node2D) -> void:
	if body is player_frogge:
		$StateChart.send_event("character_nearby")


func _on_surpise_state_entered() -> void:
	#$Debugger.visible = true
	state_machine.travel("surprise")


func _on_run_area_body_entered(body: Node2D) -> void:
	if body is player_frogge:
		flee_body = body
		$StateChart.send_event("character_too_close")


func _on_idle_state_entered() -> void:
	#get_tree().create_timer(2).timeout.connect(func(): $Debugger.visible = false)
	state_machine.travel("idle%d" % randi_range(1,3))
	velocity = Vector2.ZERO
	flee_body = null


func _on_wander_state_entered() -> void:
	#$Debugger.visible = true
	target = Vector2(global_position.x + randf_range(-50, 50), global_position.y + randf_range(-50, 50))

	_go_to(target)

func _go_to(target: Vector2) -> void:
	var raw_direction: Vector2 = (target - global_position).normalized()
	queue_redraw()
		
	state_machine.travel("run")
	
	#var direction: Vector2
	#if abs(raw_direction.x) > abs(raw_direction.y):
		#direction = Vector2(sign(raw_direction.x), 0)
	#else:
		#direction = Vector2(0, sign(raw_direction.y))

	velocity = raw_direction * move_speed

	if global_position.distance_to(target) < 5:
		velocity = Vector2.ZERO

func _draw() -> void:
	draw_line(global_position, (target), Color.GREEN, 1.0)
	draw_circle(to_local(target), 3, Color.RED)


func _on_surprise_area_body_exited(body: Node2D) -> void:
	if body is player_frogge:
		flee_body = null
		$StateChart.send_event("character_left")
