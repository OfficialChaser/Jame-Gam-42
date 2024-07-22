extends TileMap



func _on_tile_decay_timer_timeout():
	print(get_global_mouse_position())
	var tile_position : Vector2i
	while true:
		tile_position = local_to_map(
			Vector2(
				randf_range(-300, 300),
				randf_range(-175, 175)
			)
		)
		var tile_data = get_cell_tile_data(0, tile_position)
		print(tile_data)
		if tile_data.get_custom_data("walkable"):
			break
	set_cell(0, tile_position, 0, Vector2i(0, 0), 2)
