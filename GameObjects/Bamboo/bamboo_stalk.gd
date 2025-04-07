@tool
class_name BambooStalk
extends Node2D

# TODO: bamboo texture

@onready var tilemap : TileMapLayer = %BambooTiles
@onready var trigger : StaticBody2D = %Trigger

func _ready() -> void:
	rebuild_stalk()

func rebuild_stalk() -> void:
	tilemap.clear()
	for height in range(length_underwater + 1, length + 1):
		tilemap.set_cell(Vector2i.UP * height, 0, Vector2i.ZERO, 2)

@export var length : int = 1:
	get:
		return length
	set(new_length):
		length = new_length
		if is_inside_tree() and Engine.is_editor_hint():
			rebuild_stalk()

#region Water

@export var length_underwater : int = 0

func is_in_water() -> bool:
	return length_underwater > 0

var segments_above_water : int:
	get:
		return length - length_underwater

func submerge(depth : int) -> void:
	submerge_instant(depth)

func submerge_instant(depth : int) -> void:
	assert(depth - 1)
	length_underwater = depth
	erase_segments(0, length_underwater)

#endregion

#region Climbing

var min_climbing_y : float:
	get:
		return get_segment_climbing_y(length_underwater + 1)

var max_climbing_y : float:
	get:
		return get_segment_climbing_y(length)

func get_segment_climbing_y(segment_idx : int) -> float:
	return tilemap.position.y - get_segment_size().y * (-0.5 + segment_idx)

func get_climbing_position(climb_y : float) -> Vector2:
	return to_global(Vector2.DOWN * climb_y)

func get_climbing_bottom() -> Vector2:
	return get_climbing_position(min_climbing_y)

#endregion


#region Chopping

var choppable_segments : int:
	get:
		if is_in_water():
			return segments_above_water
		else:
			return length

var choppable_top_segments : int:
	get:
		# "-1" because this is only used when chopping from climb state
		return max(0, choppable_segments - 1)

func chop_from_ground() -> BambooItem:
	assert(not is_in_water())
	var result := BambooItem.new()
	result.length = length
	chop_stalk(0)
	return result

func chop_at_position(pos : Vector2) -> BambooItem:
	return chop_at_position_local(tilemap.to_local(pos))

# Local to tilemap
func chop_at_position_local(local_position : Vector2) -> BambooItem:
	var chop_segment_idx : int = get_segment_idx_at_position_local(local_position)
	# We chop segment abome us
	return chop_from_top(length - chop_segment_idx)

# 1-based
func get_segment_idx_at_position_local(local_pos : Vector2) -> int:
	var tile_coords : Vector2i = tilemap.local_to_map(local_pos)
	var segment_idx : int = clamp(-tile_coords.y, 1, length)
	return segment_idx

func chop_from_top(chop_length : int = 1) -> BambooItem:
	if chop_length < 1:
		return null
	assert(chop_length <= choppable_top_segments)
	var result := BambooItem.new()
	result.length = chop_length
	chop_stalk(length - chop_length)
	return result

func chop_stalk(new_length : int) -> void:
	if new_length < 1:
		trigger.collision_layer = 0
	erase_segments(new_length + 1, length)
	length = new_length
	# TODO: await chopping VFX
	#await get_tree().create_timer(2).timeout
	if new_length < 1:
		Game.field.unregister_bamboo(self)
		queue_free()

#endregion

#region Segments

func get_segment_size() -> Vector2i:
	return tilemap.tile_set.tile_size

func erase_segments(start_idx : int, end_idx : int) -> void:
	for segment_idx in range(start_idx, end_idx + 1):
		erase_segment(segment_idx)

func erase_segment(segment_idx : int) -> void:
	tilemap.erase_cell(Vector2i.UP * segment_idx)

#endregion
