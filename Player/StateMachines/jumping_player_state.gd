class_name JumpingMovementState
extends PlayerMovementState

# TODO: jump sfx

@export var jump_timer : Timer
@export var bamboo_scene : PackedScene

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

var jumping_into_water : bool = false
var jumping_to_bamboo : bool = false
var cell_jump_target : Vector2i

func calc_overjump() -> float:
	return MAX_OVERJUMP_Y / MAX_DIFF * min(MAX_DIFF, abs(jump_delta_y))

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	assert(Player.jump_target)
	jumping_to_bamboo = Player.climbed_stalk != null
	cell_jump_target = Game.field.global_to_map(Player.jump_target) if not jumping_to_bamboo else Game.field.global_to_map(Player.climbed_stalk.global_position)
	jumping_into_water = not jumping_to_bamboo and Game.field.is_water_cell(cell_jump_target)
	jump_start = Player.global_position
	peak_y = min(jump_start.y, jump_target.y) - calc_overjump()
	peak_alpha = (1.0 + (-jump_delta_y / MAX_DIFF)) / 2.0
	jump_timer.start()
	if jumping_into_water:
		bamboo_coroutine()
	await jump_timer.timeout
	if Player.climbed_stalk:
		request_transition("ClimbingPlayerState")
	else:
		request_transition("IdlePlayerState")

var spawned_bamboo : BambooStalk = null
var bamboo_initial_rotation : float = 15.0

func bamboo_coroutine() -> void:
	# TODO: await anim and play SFX
	spawned_bamboo = bamboo_scene.instantiate() as BambooStalk
	spawned_bamboo.rotation_degrees = bamboo_initial_rotation
	spawned_bamboo.init_from_item(Player.selected_bamboo)
	Player.selected_bamboo.queue_free()
	Player.add_child(spawned_bamboo)
	await get_tree().create_timer(peak_alpha * jump_timer.wait_time).timeout
	spawned_bamboo.plant_at_coords(cell_jump_target)
	Player.climbed_stalk = spawned_bamboo
	spawned_bamboo.submerge_timed(Game.field.get_water_depth(cell_jump_target), jump_timer.time_left)

func exit(next_state : State) -> void:
	Player.jump_target = Vector2.ZERO
	spawned_bamboo = null
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	var curr_alpha := alpha
	var pos_x : float = lerp(jump_start.x, jump_target.x, curr_alpha)
	var pos_y : float = lerp(jump_start.y, peak_y, curr_alpha / peak_alpha) if curr_alpha < peak_alpha else lerp(peak_y, jump_target.y, (curr_alpha - peak_alpha) / (1.0 - peak_alpha))
	Player.global_position = Vector2(pos_x, pos_y)
	if spawned_bamboo and curr_alpha < peak_alpha:
		spawned_bamboo.rotation_degrees = lerp(bamboo_initial_rotation, 0.0, curr_alpha / peak_alpha)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
