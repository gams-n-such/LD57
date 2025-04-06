class_name ClimbingPlayerState
extends PlayerMovementState

# TODO: climbing logic
# TODO: climbing anim
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
	current_height = current_height

func exit(next_state : State) -> void:
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	if Input.is_action_just_pressed("chop"):
		request_transition("ChoppingPlayerState")
	elif Input.is_action_just_pressed("jump"):
		Player.jump_target = stalk_root
		Player.climbed_stalk = null
		request_transition("JumpingPlayerState")
	else:
		super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
	var move_input := Player.get_move_vector()
	if move_input:
		current_height += move_input.y * speed * delta
