class_name WalkingMovementState
extends PlayerMovementState

# TODO: walking logic
# TODO: walking anim
# TODO: walking SFX

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
