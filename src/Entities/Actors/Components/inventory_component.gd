class_name InventoryComponent
extends Component

var items: Array[Entity]
var capacity: int

func _init(cnt: int) -> void:
	items = []
	capacity = cnt

func drop(item: Entity) -> void:
	items.erase(item)
	var map_data:= get_map_data()
	map_data.entities.append(item)
	map_data.entity_placed.emit(item)
	item.map_data = map_data
	item.grid_position = entity.grid_position
	MessageLog.send_message("You dropped the %s." % item.get_entity_name(), Color.WHITE)
