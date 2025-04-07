#class_name GameScript
extends Node

@export var main_menu_scene : PackedScene
@export var gameplay_scene : PackedScene
@export var inventory_screen : PackedScene

var player : PlayerCharacter
var camera : GameCamera
@onready var ui_layer : CanvasLayer = %UILayer
var field : PlayingField:
	get:
		return field
	set(new_field):
		if is_instance_valid(field):
			field.on_player_entered_win_zone.disconnect(_on_player_entered_win_zone) 
		field = new_field
		if is_instance_valid(field):
			field.on_player_entered_win_zone.connect(_on_player_entered_win_zone) 

func is_in_gameplay() -> bool:
	return field != null

func _ready() -> void:
	# TODO: load custom config
	pass

func play() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func restart() -> void:
	get_tree().reload_current_scene()

func exit_to_title() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func set_paused(pause : bool) -> void:
	get_tree().paused = pause

func open_inventory() -> void:
	var inventory = inventory_screen.instantiate()
	ui_layer.add_child(inventory)

func _on_player_entered_win_zone() -> void:
	# TODO: winning
	pass
