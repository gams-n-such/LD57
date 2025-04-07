#class_name GameScript
extends Node

@export var main_menu_scene : PackedScene
@export var gameplay_scene : PackedScene

var player : PlayerCharacter
var field : PlayingField
var camera : GameCamera

func is_in_gameplay() -> bool:
	return field != null

func _ready() -> void:
	# TODO: load custom config
	pass

func play() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func exit_to_title() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
