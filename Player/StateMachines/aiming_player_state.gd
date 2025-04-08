class_name AimingMovementState
extends PlayerMovementState

@export var ignore_player_cell : bool = true
@export var depth_gauge_scene : PackedScene
var depth_gauge : DepthGauge = null

var player_cell : Vector2i
var selected_cell : Vector2i:
	get:
		return selected_cell
	set(new_cell):
		selected_cell = new_cell
		depth_gauge.measure_cell(selected_cell)
var available_selection : Array[Vector2i]
var prev_state_name : String

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	depth_gauge = depth_gauge_scene.instantiate() as DepthGauge
	get_tree().root.add_child(depth_gauge)
	prev_state_name = prev_state.name
	#Player.was_on_stalk_pre_jump = prev_state_name == "ClimbingPlayerState"
	var player_field_position := Player.global_position if Player.climbed_stalk == null else Player.climbed_stalk.global_position
	player_cell = Game.field.global_to_map(player_field_position)
	available_selection = []
	update_available_selection()
	if available_selection.is_empty():
		request_transition(prev_state_name)
	else:
		set_selected_cell(available_selection.front())
	Player.on_bamboo_selected.connect(_on_player_selected_bamboo)

func _on_player_selected_bamboo(new_bamboo : BambooItem) -> void:
	update_available_selection()

func player_has_bamboo() -> bool:
	return is_instance_valid(Player.selected_bamboo)

func update_available_selection() -> void:
	available_selection = []
	var has_bamboo : bool = player_has_bamboo()
	var surrounding_cells : Array[Vector2i] = Game.field.interactive_tilemap.get_surrounding_cells(player_cell)
	for cell in surrounding_cells:
		if Game.field.can_player_jump_to(cell, has_bamboo):
			available_selection.append(cell)

func exit(next_state : State) -> void:
	clear_selection()
	Player.on_bamboo_selected.disconnect(_on_player_selected_bamboo)
	depth_gauge.queue_free()
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		if Game.field.can_player_jump_to(selected_cell, player_has_bamboo()):
			if Game.field.has_bamboo_in(selected_cell) and Player.climbed_stalk != Game.field.get_bamboo_in(selected_cell):
				Player.climbed_stalk = Game.field.get_bamboo_in(selected_cell)
			else:
				Player.climbed_stalk = null
			Player.jump_target = Game.field.map_to_global(selected_cell)
			request_transition("JumpingPlayerState")
	elif Input.is_action_just_pressed("aim"):
		request_transition(prev_state_name)
	elif Input.is_action_just_pressed("aim_up"):
		move_selection(Vector2i.UP)
	elif Input.is_action_just_pressed("aim_down"):
		move_selection(Vector2i.DOWN)
	elif Input.is_action_just_pressed("aim_left"):
		move_selection(Vector2i.LEFT)
	elif Input.is_action_just_pressed("aim_right"):
		move_selection(Vector2i.RIGHT)

func move_selection(direction : Vector2i) -> bool:
	var desired_cell := selected_cell + direction
	if desired_cell == player_cell and ignore_player_cell:
		desired_cell = desired_cell + direction
	if available_selection.has(desired_cell):
		set_selected_cell(desired_cell)
		return true
	elif available_selection.has(desired_cell + Vector2i.LEFT):
		set_selected_cell(desired_cell + Vector2i.LEFT)
		return true
	elif available_selection.has(desired_cell + Vector2i.RIGHT):
		set_selected_cell(desired_cell + Vector2i.RIGHT)
		return true
	else:
		return false

func set_selected_cell(new_cell : Vector2i) -> void:
	selected_cell = new_cell
	Game.field.select_cells(selected_cell, available_selection)

func clear_selection() -> void:
	Game.field.clear_selection()

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
