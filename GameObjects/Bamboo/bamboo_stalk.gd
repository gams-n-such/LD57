@tool
class_name BambooStalk
extends Node2D

# TODO: bamboo texture

@export var length : int = 1:
	get:
		return length
	set(new_length):
		length = new_length
		if is_inside_tree():
			rebuild_stalk()
@export var length_underwater : int = 0

var segments : Array[BambooSegment]

var tilemap : TileMapLayer


func _ready() -> void:
	rebuild_stalk()
	pass

func rebuild_stalk() -> void:
	%BambooTiles.clear()
	for height in range(1, length + 1):
		%BambooTiles.set_cell(Vector2i.UP * height, 0, Vector2i.ZERO, 2)

#region Segments

func get_segment_size() -> Vector2i:
	return %BambooTiles.tile_set.tile_size

#endregion
