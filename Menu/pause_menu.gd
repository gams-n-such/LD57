extends Control

func _enter_tree() -> void:
	get_tree().paused = true

func _exit_tree() -> void:
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	queue_free()

func _on_menu_button_pressed() -> void:
	Game.exit_to_title()
	queue_free()
