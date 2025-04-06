extends Control




func _on_ok_button_pressed() -> void:
	apply_config()
	queue_free()

func _on_cancel_button_pressed() -> void:
	queue_free()


@export var available_configs : Array[GameConfig]


func apply_config() -> void:
	pass

func edit_config(new_config : GameConfig) -> void:
	pass
