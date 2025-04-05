class_name PlayingField
extends Node2D

@export var bamboo_scene : PackedScene
@export var puddle_scene : PackedScene

func _enter_tree() -> void:
	if not Engine.is_editor_hint():
		Game.field = self
