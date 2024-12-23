extends TileMap

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var circle_highlight = get_tree().get_first_node_in_group("circle_highlight")
@onready var tile_decay_sfx = $TileDecaySFX

func _on_tile_decay_timer_timeout():
	if GameManager.game_over:
		return
		
	var tile_position = find_random_tile()
	circle_highlight.visible = true
	circle_highlight.global_position = map_to_local(tile_position)
	
	# Playing animation
	tile_decay_sfx.global_position = circle_highlight.global_position
	tile_decay_sfx.play()
	decay_tile(tile_position)

func check_overlapping_tile(object : Node2D):
	var tile_pos : Vector2i = local_to_map(
		object.global_position
	)
	var tile_data = get_cell_tile_data(0, tile_pos)
	if tile_data.get_custom_data("pit"):
		if "Player" in object.name:
			GameManager.place_of_death = map_to_local(tile_pos)
			player.die_by_falling()
		else:
			object.queue_free()

func find_random_tile() -> Vector2i:
	var tile_position : Vector2i
	var found_walkable_tile = false
	while not found_walkable_tile:
		# Picking a random tile to remove
		tile_position = local_to_map(
			Vector2(
				randf_range(-175, 175),
				randf_range(-75, 75)
			)
		)
		var tile_data = get_cell_tile_data(0, tile_position)
		if tile_data.get_custom_data("walkable") and (
			not tile_data.get_custom_data("breaking")
		):
			found_walkable_tile = true
	return tile_position

func restore_tiles(pos : Vector2) -> bool:
	var can_restore_tiles := false
	var middle_tile_pos = local_to_map(pos)
	var middle_tile_data = get_cell_tile_data(0, middle_tile_pos)
	
	if middle_tile_data.get_custom_data("walkable") or middle_tile_data.get_custom_data("pit"):
		can_restore_tiles = true
		
	if can_restore_tiles:
		for x in [middle_tile_pos.x - 1, middle_tile_pos.x, middle_tile_pos.x + 1]:
			for y in [middle_tile_pos.y - 1, middle_tile_pos.y, middle_tile_pos.y + 1]:
				var tile_position = Vector2i(x, y)
				var tile_data = get_cell_tile_data(0, tile_position)
				if tile_data.get_custom_data("pit"):
					set_cell(0, tile_position, 0, Vector2i(1, 0))
		return true
	else:
		return false


# Tile Animation
func decay_tile(tile_position : Vector2i):
	
	# Halfway broken tile
	set_cell(0, tile_position, 0, Vector2i(2, 0))
	
	# Wait time
	await get_tree().create_timer(1).timeout
	
	# Change to the pit
	set_cell(0, tile_position, 0, Vector2i(0, 0))
