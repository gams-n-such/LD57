# TODO: determine size
class_name PlayerCharacter
extends CharacterBody2D


func _process(delta: float) -> void:
	
	var input : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	pass
