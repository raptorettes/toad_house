@tool
extends BTAction

@export var position_var: StringName = &"move_target"
@export var arrival_distance: float = 8.0

func _generate_name() -> String:
	return "Wander  ➜%s" % LimboUtility.decorate_var(position_var)

func _enter() -> void:
	var frog = scene_root
	frog.state_machine.travel("run")
	frog.velocity = Vector2.ZERO

func _tick(_delta: float) -> Status:
	var frog = scene_root
	var target: Vector2 = blackboard.get_var(position_var, frog.global_position)
	var direction: Vector2 = (target - frog.global_position).normalized()

	if frog.sprite:
		if direction.x < 0:
			frog.sprite.flip_h = true
		elif direction.x > 0:
			frog.sprite.flip_h = false

	frog.velocity = direction * frog.move_speed
	frog.move_and_slide()

	if frog.global_position.distance_to(target) < arrival_distance:
		frog.velocity = Vector2.ZERO
		return SUCCESS
	return RUNNING
