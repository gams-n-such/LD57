class_name ChoppingMovementState
extends PlayerMovementState

# TODO: chopping SFX

@export var chop_timer : Timer

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	if Player.climbed_stalk:
		Player.sprite.play("chopping_bamboo")
	else:
		Player.sprite.play("chopping_ground")
	await Player.sprite.animation_finished
	if Player.climbed_stalk:
		var new_item : BambooItem = Player.climbed_stalk.chop_at_position(Player.global_position)
		if new_item:
			Player.inventory.add_bamboo(new_item)
		request_transition("ClimbingPlayerState")
	else:
		var stalk : BambooStalk = Player.get_faced_bamboo()
		if stalk:
			var new_item : BambooItem = stalk.chop_from_ground()
			if new_item:
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
