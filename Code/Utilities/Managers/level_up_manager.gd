class_name LevelUpManager extends Node2D


var levels_to_do:int = 0
var level_up_in_progress:bool = false
var level_just_complete:bool = false
var delay:float = 3
var timer:float = 0:
	set(value):
		timer = value
		if timer >= delay:
			level_just_complete = false
			timer = 0


func _ready() -> void:
	Signals.PlayerlevelUp.connect(_add_level_up)
	Signals.LevelUpComplete.connect(_level_up_complete)
	Signals.LevelUpSelection.connect(_level_up_selection)
	Signals.ManagerReady.emit(self)


func _process(delta: float) -> void:
	if not level_just_complete and not level_up_in_progress and levels_to_do > 0:
		_display_level_up()
	
	if level_just_complete: timer += delta


func get_level_up_datas() -> Array[SkillData]:
	var possibles:Array[String] = []
	var result:Array[SkillData] = []
	var ignore:Array[String] = []

	for each in Game.player_manager.all_active_skills:
		if each.data.current_level < Game.SKILLLEVELCAP:
			possibles.append(each.data.id)
		else:
			ignore.append(each.data.id)

	for each in Game.player_manager.all_skills:
		if not possibles.has(each.id) and not ignore.has(each.id):
			possibles.append(each.id)

	if not possibles.is_empty():
		for each in Game.get_random_from_array(possibles, 3):
			result.append(Game.player_manager.get_data_by_id(each))

	return result


func _display_level_up() -> void:
	levels_to_do -= 1
	get_tree().paused = true
	Signals.ToggleUi.emit("level_up_screen")


func _add_level_up(_level) -> void:
	levels_to_do += 1


func _level_up_complete() -> void:
	level_just_complete = true


func _level_up_selection(_id:String) -> void:
	if Game.player_manager.has_active_skill(_id):
		Signals.UpdateActiveSkill.emit(_id)
	else:
		Signals.AddNewSkill.emit(Game.player_manager.get_data_by_id(_id))

