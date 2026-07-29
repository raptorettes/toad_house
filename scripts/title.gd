extends CanvasLayer

@onready var canvas_container = $CenterContainer
@onready var label = $CenterContainer/VBoxContainer
@onready var click_sound = $ClickSound

var can_start: bool = false
var rest_y: float

func _ready():
	var rest_y = label.position.y
	label.position.y = rest_y - 0.0
	label.modulate.a = 0.0

	var tween = create_tween()
	tween.set_parallel(false)

	tween.tween_property(label, "modulate:a", 1.0, 0.3)
	tween.tween_property(label, "position:y", rest_y, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(label, "position:y", rest_y - 8.0, 0.08)
	tween.tween_property(label, "position:y", rest_y, 0.08)
	tween.tween_interval(0.8)
	tween.tween_callback(func(): can_start = true)
	_start_float()

func _start_float() -> void:
	var float_tween = create_tween()
	float_tween.set_loops()
	float_tween.tween_property(label, "position:y", label.position.y - 8.0, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	float_tween.tween_property(label, "position:y", label.position.y, 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _input(event):
	if not can_start:
		return
	if event is InputEventKey and event.is_pressed():
		_start_game()
	elif event is InputEventMouseButton and event.pressed:
		_start_game()

func _start_game():
	can_start = false
	click_sound.play()
	var tween = create_tween()
	tween.tween_property(canvas_container, "modulate:a", 0.0, 0.4)
	tween.tween_callback(
		func():
			get_tree().change_scene_to_file("res://scenes/main_game.tscn"))
	
