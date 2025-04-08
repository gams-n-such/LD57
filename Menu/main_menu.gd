class_name MainMenu
extends Control

@export var tutorial_screen_scene : PackedScene
@export var config_screen_scene : PackedScene
@export var credits_screen_scene : PackedScene
var config_screen : Control = null

func _on_play_button_pressed() -> void:
	Game.play()

func _on_config_button_pressed() -> void:
	config_screen = config_screen_scene.instantiate() as Control
	add_child(config_screen)

func _on_credits_button_pressed() -> void:
	add_child(credits_screen_scene.instantiate())


func _on_tutorial_button_pressed() -> void:
	add_child(tutorial_screen_scene.instantiate())
