class_name PlayerMovementState
extends State

var Player : PlayerCharacter
var AnimPlayer : AnimationPlayer


func _ready() -> void:
	await owner.ready
	Player = owner as PlayerCharacter
	AnimPlayer = Player.ANIMATION_PLAYER

func update(delta: float) -> void:
	movement_update(delta)

func physics_update(delta: float) -> void:
	pass

func movement_update(delta : float) -> void:
	pass
