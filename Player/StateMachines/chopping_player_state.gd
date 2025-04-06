class_name ChoppingMovementState
extends PlayerMovementState

# TODO: chopping anim
# TODO: chopping SFX
# TODO: chopping logic

@export var chop_timer : Timer
var climbed_stalk : BambooStalk = null
var grounded : bool:
	get:
		return climbed_stalk == null

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	if prev_state is ClimbingPlayerState:
		climbed_stalk = (prev_state as ClimbingPlayerState).stalk
	else:
		climbed_stalk = null
	chop_timer.start()
	await chop_timer.timeout
	if climbed_stalk:
		var new_item : BambooItem = climbed_stalk.chop_at_position(Player.global_position)
		Player.inventory.add_bamboo(new_item)
		request_transition("ClimbingPlayerState")
	else:
		var stalk : BambooStalk = Player.get_faced_bamboo()
		if stalk:
			var new_item : BambooItem = climbed_stalk.chop_from_ground()
			Player.inventory.add_bamboo(new_item)
		request_transition("IdlePlayerState")

func exit(next_state : State) -> void:
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
