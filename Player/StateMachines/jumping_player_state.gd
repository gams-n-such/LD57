class_name JumpingMovementState
extends PlayerMovementState

# TODO: jump sfx

@export var jump_timer : Timer

var alpha : float:
	get:
		return 1.0 - (jump_timer.time_left / jump_timer.wait_time)

var jump_start : Vector2
var jump_target : Vector2:
	get:
		return Player.jump_target
var jump_delta_y : float:
	get:
		return jump_target.y - jump_start.y

var peak_y : float
var peak_alpha : float
var MAX_OVERJUMP_Y : float = 50.0
var MAX_DIFF : float = 200.0

func calc_overjump() -> float:
	return MAX_OVERJUMP_Y / MAX_DIFF * min(MAX_DIFF, abs(jump_delta_y))

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	assert(Player.jump_target)
	jump_start = Player.global_position
	peak_y = min(jump_start.y, jump_target.y) - calc_overjump()
	peak_alpha = (1.0 + (-jump_delta_y / MAX_DIFF)) / 2.0
	jump_timer.start()
	await jump_timer.timeout
	if Player.climbed_stalk:
		request_transition("ClimbingPlayerState")
	else:
		request_transition("IdlePlayerState")

func exit(next_state : State) -> void:
	Player.jump_target = Vector2.ZERO
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	var curr_alpha := alpha
	var pos_x : float = lerp(jump_start.x, jump_target.x, curr_alpha)
	var pos_y : float = lerp(jump_start.y, peak_y, curr_alpha / peak_alpha) if curr_alpha < peak_alpha else lerp(peak_y, jump_target.y, (curr_alpha - peak_alpha) / (1.0 - peak_alpha))
	Player.global_position = Vector2(pos_x, pos_y)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
