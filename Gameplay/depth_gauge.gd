class_name DepthGauge
extends Control


func measure_cell(cell : Vector2i) -> void:
	visible = not Game.field.can_player_jump_to(cell, false)
	global_position = Game.field.map_to_global(cell)
	if Game.field.is_water_cell(cell):
		$Label.text = str(Game.field.get_water_depth(cell))
