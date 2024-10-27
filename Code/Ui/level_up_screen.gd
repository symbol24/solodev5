class_name LevelUpScreen extends SyPanelContainer


@export var level_card:PackedScene

@onready var choices: HBoxContainer = %choices

var active_choices:Array[LevelUpCard] = []


func toggle_panel(display:bool) -> void:
	if display:
		show()
		_setup_cards(Game.level_up_manager.get_level_up_datas())
	else:
		hide()
		_clear_choices()


func _setup_cards(_datas:Array[SkillData]) -> void:
	for each in _datas:
		var new:LevelUpCard = level_card.instantiate()
		choices.add_child(new)
		if not new.is_node_ready():
			await new.ready
		new.set_data(each)
		active_choices.append(new)


func _clear_choices() -> void:
	for each in active_choices:
		each.queue_free.call_deferred()
	active_choices.clear()
