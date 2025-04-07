#class_name GameScript
extends Node

@export var main_menu_scene : PackedScene
@export var gameplay_scene : PackedScene
@export var inventory_screen : PackedScene

var player : PlayerCharacter
var field : PlayingField
var camera : GameCamera
var ui_viewport : SubViewport

func is_in_gameplay() -> bool:
	return field != null

func _ready() -> void:
	# TODO: load custom config
	pass

func play() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func exit_to_title() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func set_paused(pause : bool) -> void:
	get_tree().paused = pause

func open_inventory() -> void:
	var inventory = inventory_screen.instantiate()
	%UILayer.add_child(inventory)
