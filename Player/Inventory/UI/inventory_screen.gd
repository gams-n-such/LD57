extends Control

@export var item_control_scene : PackedScene
@export var item_theme : Theme
@export var selected_item_theme : Theme

@onready var items_container : Control = %ItemsBox

func _enter_tree() -> void:
	Game.set_paused(true)

func _exit_tree() -> void:
	Game.set_paused(false)


var selected_item : BambooItem:
	get:
		return Game.player.selected_bamboo

var selected_control : BambooItemControl:
	get:
		return selected_control
	set(new_control):
		if selected_control != null:
			selected_control.theme = item_theme
		selected_control = new_control
		if selected_control != null:
			selected_control.theme = selected_item_theme

func _ready() -> void:
	for item in Game.player.inventory.get_bamboos():
		add_item(item)

func add_item(item : BambooItem) -> void:
	var item_control := item_control_scene.instantiate() as BambooItemControl
	item_control.item = item
	item_control.on_item_selected.connect(handle_item_selected)
	if selected_item == item:
		selected_control = item_control
	items_container.add_child(item_control)

func handle_item_selected(control : BambooItemControl) -> void:
	selected_control = control
	Game.player.selected_bamboo = control.item


func _on_ok_button_pressed() -> void:
	queue_free()
