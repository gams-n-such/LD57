extends Control


func set_win(win : bool):
	%WinLabel.visible = win
	%LoseLabel.visible = not win

func _on_menu_button_pressed() -> void:
	Game.exit_to_title()
	queue_free()
