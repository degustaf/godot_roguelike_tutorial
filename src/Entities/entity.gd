class_name Entity
extends Sprite2D

enum AIType {NONE, HOSTILE}
enum EntityType {CORPSE, ITEM, ACTOR}

const entity_types = {
	"player": "res://assets/definitions/entities/actors/entity_definition_player.tres",
	"orc": "res://assets/definitions/entities/actors/entity_definition_orcs.tres",
	"troll": "res://assets/definitions/entities/actors/entity_definition_troll.tres",
	"health_potion": "res://assets/definitions/entities/items/health_potion_definition.tres",
	"lightning_scroll": "res://assets/definitions/entities/items/lightning_scroll_definition.tres",
	"confusion_scroll": "res://assets/definitions/entities/items/consusion_scroll_definition.tres",
	"fireball_scroll": "res://assets/definitions/entities/items/fireball_scroll_definition.tres"
}

var key: String
var _definition: EntityDefinition
var entity_name: String
var blocks_movement: bool
var map_data: MapData

var fighter_component: FighterComponent
var ai_component: BaseAIComponent
var consumable_component: ConsumableComponent
var inventory_component: InventoryComponent

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

var type: EntityType:
	set(value):
		type = value
		z_index = value

func _init(map:MapData, start_position: Vector2i, k: String) -> void:
	centered = false
	grid_position = start_position
	map_data = map
	if k != "":
		set_entity_type(k)

func move(move_offset: Vector2i) -> void:
	map_data.unregister_blocking_entity(self)
	grid_position += move_offset
	map_data.register_blocking_entity(self)

func set_entity_type(k: String) -> void:
	key = k
	_definition = load(entity_types[key])
	type = _definition.type
	blocks_movement = _definition.is_blocking_movement
	entity_name = _definition.name
	texture = _definition.texture
	modulate = _definition.color
	
	match _definition.ai_type:
		AIType.HOSTILE:
			ai_component = HostileEnemyAIComponent.new()
			add_child(ai_component)
	
	if _definition.fighter_definition:
		fighter_component = FighterComponent.new(_definition.fighter_definition)
		add_child(fighter_component)
	
	if _definition.consumable_definition:
		_handle_consumable(_definition.consumable_definition)
	
	if _definition.inventory_capacity > 0:
		inventory_component = InventoryComponent.new(_definition.inventory_capacity)
		add_child(inventory_component)

func is_blocking_movement() -> bool:
	return blocks_movement

func get_entity_name() -> String:
	return entity_name

func is_alive() -> bool:
	return ai_component != null

func distance(other_position: Vector2i) -> int:
	var relative := other_position - grid_position
	return maxi(abs(relative.x), abs(relative.y))

func _handle_consumable(consumable_definition: ConsumableComponentDefinition) -> void:
	if consumable_definition is HealingConsumableComponentDefinition:
		consumable_component = HealingConsumableComponent.new(consumable_definition)
	elif consumable_definition is LightningDamageConsumableComponentDefinition:
		consumable_component = LightningDamageConsumableComponent.new(consumable_definition)
	elif consumable_definition is ConfusionConsumableComponentDefinition:
		consumable_component = ConfusionConsumableComponent.new(consumable_definition)
	elif consumable_definition is FireballDamageConsumableComponentDefinition:
		consumable_component = FireballConsumableComponent.new(consumable_definition)
	
	if consumable_component:
		add_child(consumable_component)
	consumable_component.entity = self

func get_save_data() -> Dictionary:
	var save_data = {
		"x": grid_position.x,
		"y": grid_position.y,
		"key": key
	}
	
	if fighter_component:
		save_data["fighter_component"] = fighter_component.get_save_data()
	if ai_component:
		save_data["ai_component"] = ai_component.get_save_data()
	if inventory_component:
		save_data["inventory_component"] = inventory_component.get_save_data()
	
	return save_data

func restore(save_data: Dictionary) -> void:
	grid_position = Vector2i(save_data["x"], save_data["y"])
	set_entity_type(save_data["key"])
	
	if fighter_component and save_data.has("fighter_component"):
		fighter_component.restore(save_data["fighter_component"])
	if ai_component and save_data.has("ai_component"):
		var ai_data: Dictionary = save_data["ai_component"]
		if ai_data["type"] == "ConfusedEnemyAI":
			var confused_enemy_ai := ConfusedEnemyAIComponent.new(ai_data["turns_remaining"])
			add_child(confused_enemy_ai)
	if inventory_component and save_data.has("inventory_component"):
		inventory_component.restore(save_data["inventory_component"])
