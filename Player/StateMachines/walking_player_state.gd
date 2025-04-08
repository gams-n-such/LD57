class_name WalkingMovementState
extends PlayerMovementState

# TODO: walking logic
# TODO: walking anim
# TODO: walking SFX

@export var speed : float = 100.0

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	Player.sprite.offset = Vector2.ZERO
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
			Player.was_on_stalk_pre_jump = false
			Player.climbed_stalk = Player.get_faced_bamboo()
			Player.jump_target = Player.climbed_stalk.get_climbing_bottom()
			request_transition("JumpingPlayerState")
	elif Input.is_action_just_pressed("aim"):
		request_transition("AimingPlayerState")
	else:
		super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
	var move_input := Player.get_move_vector()
	if not move_input:
		request_transition("IdlePlayerState")
	else:
		Player.velocity = move_input * speed
		Player.face_towards(move_input)
		Player.move_and_slide()
