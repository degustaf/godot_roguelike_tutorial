class_name BumpAction
extends ActionWithDirection

func perform() -> void:
	var destination: Vector2i = get_destination()
	
	if get_blocking_entity_at_destination():
		MeleeAction.new(entity, offset.x, offset.y).perform()
	else:
		MovementAction.new(entity, offset.x, offset.y).perform()
