class_name ItemAction
extends Action

var item: Entity
var target_position: Vector2i

func _init(e: Entity, itm: Entity, target_pos = null) -> void:
	super._init(e)
	item = itm
	if target_pos is Vector2i:
		target_position = target_pos
	else:
		target_position = e.grid_position

func get_target_actor() -> Entity:
	return get_map_data().get_actor_at_location(target_position)

func perform() -> bool:
	if item == null:
		return false
	return item.consumable_component.activate(self)
