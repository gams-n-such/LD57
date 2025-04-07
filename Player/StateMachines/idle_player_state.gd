class_name IdlePlayerState
extends PlayerMovementState

# TODO: idle anim

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	# TODO:
	Player.sprite.play("walking")

func exit(next_state : State) -> void:
	if next_state is ClimbingPlayerState:
		var climb_state := next_state as ClimbingPlayerState
		climb_state.stalk = Player.get_faced_bamboo()
		assert(climb_state.stalk != null)
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	if Input.is_action_just_pressed("chop"):
		request_transition("ChoppingPlayerState")
	elif Input.is_action_just_pressed("jump"):
		if Player.is_facing_a_bamboo():
			Player.climbed_stalk = Player.get_faced_bamboo()
			Player.jump_target = Player.climbed_stalk.get_climbing_bottom()
			request_transition("JumpingPlayerState")
	elif Player.get_move_vector():
		request_transition("WalkingPlayerState")

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
