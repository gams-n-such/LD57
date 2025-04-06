@tool
class_name BambooStalk
extends Node2D

# TODO: bamboo texture

@export var length : int = 1:
	get:
		return length
	set(new_length):
		length = new_length
		if is_inside_tree() and Engine.is_editor_hint():
			rebuild_stalk()

@export var length_underwater : int = 0

func is_in_water() -> bool:
	return length_underwater > 0

var segments_above_water : int:
	get:
		return length - length_underwater

var choppable_segments : int:
	get:
		if is_in_water():
			return segments_above_water
		else:
			return length

var choppable_top_segments : int:
	get:
		# "-1" because this is only used when chopping from climb state
		return min(0, choppable_segments - 1)

@onready var tilemap : TileMapLayer = %BambooTiles

func _ready() -> void:
	rebuild_stalk()
	pass

func rebuild_stalk() -> void:
	tilemap.clear()
	for height in range(1, length + 1):
		tilemap.set_cell(Vector2i.UP * height, 0, Vector2i.ZERO, 2)


#region Chopping

func chop_from_ground() -> BambooItem:
	assert(not is_in_water())
	var result := BambooItem.new()
	result.length = length
	chop_stalk(0)
	return result

func chop_at_position(position : Vector2) -> BambooItem:
	return chop_at_position_local(to_local(position))

func chop_at_position_local(local_position : Vector2) -> BambooItem:
	var chop_segment_idx : int = get_segment_idx_at_position_local(local_position)
	# We chop segment abome us
	chop_segment_idx = chop_segment_idx + 1
	return chop_from_top(segments_above_water - chop_segment_idx)

# 1-based
func get_segment_idx_at_position_local(local_pos : Vector2) -> int:
	var tile_coords : Vector2i = tilemap.local_to_map(local_pos)
	var segment_idx : int = clamp(-tile_coords.y, 1, length)
	return segment_idx

func chop_from_top(chop_length : int = 1) -> BambooItem:
	if chop_length < 1:
		return null
	assert(chop_length < choppable_top_segments)
	var result := BambooItem.new()
	result.length = chop_length
	chop_stalk(length - chop_length)
	return result

func chop_stalk(new_length : int) -> void:
	# TODO: await chopping VFX
	length = new_length
	await get_tree().create_timer(2).timeout
	if new_length < 1:
		queue_free()

#endregion

#region Segments

func get_segment_size() -> Vector2i:
	return tilemap.tile_set.tile_size

#endregion
