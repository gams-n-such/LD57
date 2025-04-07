class_name BambooItemControl
extends Control

var item : BambooItem:
	get:
		return item
	set(new_item):
		item = new_item
		update_visual()

func update_visual() -> void:
	%Label.text = "%s x " % str(item.length)

signal on_item_selected(control : BambooItemControl)

func _on_button_pressed() -> void:
	on_item_selected.emit(self)
