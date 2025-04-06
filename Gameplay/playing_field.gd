class_name PlayingField
extends Node2D

@export_category("Objects")
@export var bamboo_scene : PackedScene
@export var puddle_scene : PackedScene

@export_category("Field size")
@export var first_gameplay_row : int = 3
@export var num_gameplay_rows : int = 3
var last_gameplay_row : int:
	get:
		return first_gameplay_row + num_gameplay_rows - 1

@export var end_zone_rows : int = 3
var last_row : int:
	get:
		return last_gameplay_row + end_zone_rows

@export var even_rows_width : int = 5

@onready var tilemap : TileMapLayer = %TileMap

func _enter_tree() -> void:
	if not Engine.is_editor_hint():
		Game.field = self

func _exit_tree() -> void:
	if not Engine.is_editor_hint():
		Game.field = null

func _ready() -> void:
	var last_row_pos_local : Vector2 = tilemap.map_to_local(Vector2i.DOWN * (last_row - 1))
	Game.camera.set_field_bottom(to_global(last_row_pos_local).y)

func generate_field() -> void:
	
	pass

#region Generation

func get_width_for_row(row_idx : int) -> int:
	return even_rows_width if row_idx % 2 == 0 else even_rows_width - 1

func generate_starting_bamboo() -> void:
	pass

func generate_gameplay_field() -> void:
	pass

func generate_win_zone() -> void:
	pass

func generate_land_row(row_idx : int) -> void:
	pass

func generate_water_row(row_idx : int) -> void:
	var row_width : int = get_width_for_row(row_idx)
	pass

func generate_gameplay_row(row_idx : int) -> void:
	var row_width : int = get_width_for_row(row_idx)
	for x in range(row_width):
		pass

func generate_water_borders(row_idx : int) -> void:
	for row in range(first_gameplay_row, last_gameplay_row + 1):
		var row_width : int = get_width_for_row(row_idx)
		set_water_border_cell(Vector2i(-1, row_idx))
		set_water_border_cell(Vector2i(row_width, row_idx))

#endregion

#region Cell Ops

func set_ground_cell(coords : Vector2i) -> void:
	tilemap.set_cell(coords, 0, Vector2i.ZERO, 1)
	tilemap.get_cell_tile_data(coords).set_custom_data("depth", 0)

func is_ground_cell(coords : Vector2i) -> bool:
	return tilemap.get_cell_tile_data(coords).get_custom_data("depth") == 0

func set_water_border_cell(coords : Vector2i) -> void:
	# TODO: alternative visuals
	#tilemap.set_cell(coords, 0, Vector2i.ZERO, 2)
	#tilemap.get_cell_tile_data(coords).set_custom_data("depth", depth)
	set_water_cell(coords, 10)

func set_water_cell(coords : Vector2i, depth : int) -> void:
	tilemap.set_cell(coords, 0, Vector2i.ZERO, 2)
	tilemap.get_cell_tile_data(coords).set_custom_data("depth", depth)

func is_water_cell(coords : Vector2i) -> bool:
	return tilemap.get_cell_tile_data(coords).get_custom_data("depth") > 0

func get_water_depth(coords : Vector2i) -> int:
	if is_water_cell(coords):
		return tilemap.get_cell_tile_data(coords).get_custom_data("depth")
	return 0

func spawn_bamboo_in_cell(coords : Vector2i, length : int, compensate_depth : bool = true) -> void:
	var new_bamboo := bamboo_scene.instantiate() as BambooStalk
	var additional_length : int = get_water_depth(coords) if compensate_depth else 0
	new_bamboo.length = length
	add_bamboo_to_cell(coords, new_bamboo)

func add_bamboo_to_cell(coords : Vector2i, bamboo : BambooStalk) -> void:
	bamboo.position = tilemap.map_to_local(coords)
	bamboo.length_underwater = get_water_depth(coords)
	add_child(bamboo)

#endregion
