extends State
class_name EnemyPursue

@export var speed : float
@export var actor : CharacterBody2D
@export var enemy_sprite : Sprite2D
@export var animation_player : AnimationPlayer

@onready var tile_map := get_tree().current_scene.get_node("GameTiles")
@onready var player := get_tree().current_scene.get_node("Player")


var astar_grid: AStarGrid2D
var is_moving : bool

func Enter():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	
	check_walkability(region_size, region_position)

func Update(_delta):
	manage_sprite()
	if is_moving:
		return
	move()

func move():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var occupied_positions = []
	
	check_walkability(astar_grid.region.size, astar_grid.region.position)
	
	for enemy in enemies:
		if enemy != self:
			occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position)
	
	var path = astar_grid.get_id_path(
		tile_map.local_to_map(actor.global_position),
		tile_map.local_to_map(player.global_position)
	)
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	occupied_positions.clear()
	path.pop_front()
	
	if path.size() == 1:
		Transitioned.emit(self, "EnemyAttack")
		return
	
	if (path.is_empty()):
		return
	
	var original_position = Vector2(actor.global_position)
	
	actor.global_position = tile_map.map_to_local(path[0])
	enemy_sprite.global_position = original_position
	
	is_moving = true

func check_walkability(region_size : Vector2i, region_position : Vector2i):
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(
				x + region_position.x,
				y + region_position.y
			)
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if (tile_data == null or !tile_data.get_custom_data("walkable")):
				astar_grid.set_point_solid(tile_position)

func _physics_process(_delta):
	if (is_moving):
		enemy_sprite.global_position = enemy_sprite.global_position.move_toward(actor.global_position, speed)
		
		if (enemy_sprite.global_position != actor.global_position):
			return
		
		is_moving = false

func manage_sprite():
	animation_player.play("Pursue")
	if (player.global_position < actor.global_position):
		enemy_sprite.flip_h = true
	elif (player.global_position > actor.global_position):
		enemy_sprite.flip_h = false
