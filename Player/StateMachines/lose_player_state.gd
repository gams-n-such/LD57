class_name LosePlayerState
extends PlayerMovementState

# TODO: idle anim

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	Player.sprite.offset = Vector2.ZERO
	Player.sprite.play("losing")
	await Player.sprite.animation_finished
	Game.game_over(false)

func exit(next_state : State) -> void:
	super.exit(next_state)

# TODO: use _process/_physics_process + process mode?
func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func movement_update(delta : float) -> void:
	super.movement_update(delta)
