# TODO: determine size
class_name PlayerCharacter
extends CharacterBody2D

@onready var inventory : PlayerInventory = %Inventory
@onready var state_machine : StateMachine = %PlayerStateMachine

func _enter_tree() -> void:
	Game.player = self

func _exit_tree() -> void:
	Game.player = null

func _ready() -> void:
	update_bamboo_detector()

func _process(delta: float) -> void:
	pass

#region Facing

var flipped : bool:
	get:
		return %AnimatedSprite.flip_h
	set(new_value):
		%AnimatedSprite.flip_h = new_value
		update_bamboo_detector()

signal on_flipped

func flip() -> void:
	flipped = !flipped
	on_flipped.emit()

var facing_vector : Vector2:
	get:
		if flipped:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT

func face_towards(target_dir : Vector2) -> void:
	if target_dir.dot(facing_vector) < 0:
		flip()

#endregion

#region Input

func set_game_input_enabled(enable : bool) -> void:
	state_machine.set_process_input(enable)

func get_move_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "climb_up", "climb_down")

func get_aim_vector() -> Vector2:
	return Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")

#endregion

#region Bamboo

@export var bamboo_detection_range : float = 20.0
@onready var bamboo_detector : ShapeCast2D = %BambooDetector

func update_bamboo_detector() -> void:
	bamboo_detector.target_position = facing_vector * bamboo_detection_range

func is_facing_a_bamboo() -> bool:
	return bamboo_detector.is_colliding()

func get_faced_bamboo() -> BambooStalk:
	if not is_facing_a_bamboo():
		return null
	return (bamboo_detector.get_collider(0) as StaticBody2D).get_parent()

#endregion

#region Climbing

var climbed_stalk : BambooStalk = null
var grounded : bool:
	get:
		return climbed_stalk == null

#endregion
