class_name MovementAction
extends Action

var offset: Vector2i

func _init(dx: int, dy: int) -> void:
	offset = Vector2i(dx, dy)

func perform(game: Game, entity: Entity):
	print("In MovementAction::perform")
	var destination: Vector2i = entity.grid_position + offset
	
	var map_data: MapData = game.get_map_data()
	var destination_tile: Tile = map_data.get_tile(destination)
	if not destination_tile:
		print("No destination_tile")
		return
	if not destination_tile.is_walkable():
		print("destination_tile is not walkable")
		return
	entity.move(offset)
