extends CharacterBody2D

@export var move_speed: float = 40.0
@export var wander_radius: float = 60.0

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D

var home_position: Vector2

@export var skins: Array[Texture2D] = []

func _ready():
	home_position = global_position
	if skins.size() > 0:
		sprite.texture = skins[randi() % skins.size()]
		
func _physics_process(_delta):
	if velocity != Vector2.ZERO:
		move_and_slide()
		
func is_good_position(pos: Vector2) -> bool:
	return pos.distance_to(home_position) <= wander_radius
