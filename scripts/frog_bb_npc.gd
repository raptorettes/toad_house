extends CharacterBody2D

@export var move_speed: float = 20.0
@export var wander_radius: float = 20.0
@export var skins: Array[Texture2D] = []
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var home_position: Vector2

func _ready():
	home_position = global_position
	if skins.size() > 0:
		sprite.texture = skins[randi() % skins.size()]

func is_good_position(pos: Vector2) -> bool:
	return pos.distance_to(home_position) <= wander_radius

func _physics_process(_delta):
	if velocity != Vector2.ZERO:
		move_and_slide()
