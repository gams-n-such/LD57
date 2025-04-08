class_name ClimbingPlayerState
extends PlayerMovementState

# TODO: climbing SFX?

@export var speed : float = 75.0

var stalk : BambooStalk:
	get:
		return Player.climbed_stalk

var stalk_root : Vector2:
	get:
		return stalk.global_position

var current_height : float:
	get:
		return Player.global_position.y - stalk_root.y
	set(new_height):
		var clamped_height : float = clamp(new_height, stalk.max_climbing_y, stalk.min_climbing_y)
		Player.global_position = stalk.get_climbing_position(clamped_height)

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	if Player.flipped:
		Player.sprite.offset.x = 8
	else:
		Player.sprite.offset.x = -4
	current_height = current_height
	if stalk.length_underwater > stalk.length:
		request_transition("LosePlayerState")
		stalk.queue_free()
	else:
		if stalk.segments_above_water < 1:
			Player.sprite.play("balancing")

func exit(next_state : State) -> void:
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	if Input.is_action_just_pressed("chop"):
		request_transition("ChoppingPlayerState")
	elif Input.is_action_just_pressed("jump") and (not is_instance_valid(Player.climbed_stalk) or not Player.climbed_stalk.is_in_water()):
		Player.jump_target = stalk_root
		Player.climbed_stalk = null
		Player.was_on_stalk_pre_jump = true
		request_transition("JumpingPlayerState")
	elif Input.is_action_just_pressed("aim"):
		Player.was_on_stalk_pre_jump = true
		request_transition("AimingPlayerState")
	else:
		super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
	var move_input := Player.get_move_vector()
	if stalk.segments_above_water < 1:
		return
	if move_input:
		current_height += move_input.y * speed * delta
	if move_input.y > 0:
		Player.sprite.play("climbing_down")
	elif move_input.y < 0:
		Player.sprite.play("climbing_up")
	else:
		Player.sprite.play("climbing_idle")
