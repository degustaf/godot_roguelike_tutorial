extends HBoxContainer

var player: Entity

@onready var level_label: Label = $LevelLabel
@onready var attack_label: Label = $AttackLabel
@onready var defense_label: Label = $DefenseLabel

func setup(p: Entity) -> void:
	player = p
	player.level_component.leveled_up.connect(update_labels)
	player.equipment_component.equipment_changed.connect(update_labels)
	update_labels()

func update_labels() -> void:
	if not player.is_inside_tree():
		await player.ready
	level_label.text = "LVL: %d" % player.level_component.current_level
	attack_label.text = "ATK: %d" % player.fighter_component.power
	defense_label.text = "DEF: %d" % player.fighter_component.defense
