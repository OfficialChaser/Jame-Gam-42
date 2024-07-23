extends TileMap

func _on_tile_decay_timer_timeout():
	
	
	var tile_position = find_random_tile()
	
	# Playing animation
	decay_tile(tile_position)

func check_overlapping_tile(actor : CharacterBody2D):
	var tile_pos : Vector2i = local_to_map(
		actor.global_position
	)
	var tile_data = get_cell_tile_data(0, tile_pos)
	if tile_data.get_custom_data("pit"):
		print("kill player")
		get_tree().reload_current_scene()

func find_random_tile() -> Vector2i:
	var tile_position : Vector2i
	var found_walkable_tile = false
	while not found_walkable_tile:
		# Picking a random tile to remove
		tile_position = local_to_map(
			Vector2(
				randf_range(-250, 250),
				randf_range(-150, 150)
			)
		)
		var tile_data = get_cell_tile_data(0, tile_position)
		if tile_data.get_custom_data("walkable"):
			found_walkable_tile = true
	return tile_position

func restore_tiles(pos : Vector2):
	var middle_tile_pos = local_to_map(pos)
	for x in [middle_tile_pos.x - 1, middle_tile_pos.x, middle_tile_pos.x + 1]:
		for y in [middle_tile_pos.y - 1, middle_tile_pos.y, middle_tile_pos.y + 1]:
			var tile_position = Vector2i(x, y)
			var tile_data = get_cell_tile_data(0, tile_position)
			if tile_data.get_custom_data("pit"):
				set_cell(0, tile_position, 0, Vector2i(1, 0))


# Tile Animation
func decay_tile(tile_position : Vector2i):
	
	# Halfway broken tile
	set_cell(0, tile_position, 0, Vector2i(2, 0))
	
	# Wait time
	await get_tree().create_timer(1).timeout
	
	# Change to the pit
	set_cell(0, tile_position, 0, Vector2i(0, 0))
