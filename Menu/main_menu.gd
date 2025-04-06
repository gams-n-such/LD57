class_name MainMenu
extends Control

@export var config_screen_scene : PackedScene
var config_screen : Control = null

func _on_play_button_pressed() -> void:
	Game.play()

func _on_config_button_pressed() -> void:
	config_screen = config_screen_scene.instantiate() as Control
	add_child(config_screen)
