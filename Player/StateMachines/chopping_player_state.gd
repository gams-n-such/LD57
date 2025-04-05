class_name ChoppingMovementState
extends PlayerMovementState

# TODO: chopping anim
# TODO: chopping SFX
# TODO: chopping logic

func enter(prev_state : State) -> void:
	super.enter(prev_state)

func exit(next_state : State) -> void:
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
