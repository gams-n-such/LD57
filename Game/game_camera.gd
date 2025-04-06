class_name GameCamera
extends Camera2D

func _enter_tree() -> void:
	Game.camera = self

func _exit_tree() -> void:
	Game.camera = null

func set_field_bottom(max_y : float) -> void:
	limit_bottom = max_y
