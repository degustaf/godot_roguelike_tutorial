class_name Action
extends RefCounted

var entity: Entity

func _init(e: Entity) -> void:
	entity = e

func perform():
	pass

func get_map_data() -> MapData:
	return entity.map_data
