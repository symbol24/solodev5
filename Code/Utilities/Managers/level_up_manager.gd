class_name LevelUpManager extends Node2D


@export var no_skill:SkillData
@export var card_disabled_timer:float = 0.5

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


func get_level_up_datas() -> Array[SytoData]:
	var result:Array[SytoData] = []
	var ignore:Array[int] = []

	var all:Array = []
	all.append_array(Game.data_manager.starter_skills)
	all.append_array(Game.save_load.active_save.unlocked_skills)
	all.append_array(Game.data_manager.starter_boosters)
	all.append_array(Game.save_load.active_save.unlocked_boosters)

	var test:Array = []
	test.append_array(Game.data_manager.starter_skills)
	test.append_array(Game.save_load.active_save.unlocked_skills)
	test.append_array(Game.data_manager.starter_boosters)
	test.append_array(Game.save_load.active_save.unlocked_boosters)

	var x:int = 0
	for each in all:
		if each.current_level >= Game.SKILLLEVELCAP:
			ignore.append(x)
		x += 1

	x = ignore.size() - 1
	while x > 0:
		var pos:int = ignore[x]
		all.remove_at(pos)

	if not all.is_empty():
		for each in Game.get_random_from_array(all, 3):
			result.append(each)
	else:
		result.append(no_skill)

	return result


func _display_level_up() -> void:
	levels_to_do -= 1
	get_tree().paused = true
	Signals.ToggleUi.emit("level_up_screen")


func _add_level_up(_level) -> void:
	levels_to_do += 1


func _level_up_complete() -> void:
	level_just_complete = true


func _level_up_selection(_data:SytoData) -> void:
	#Debug.log("Received signal for data: ", _data.id)
	var is_update:bool = false
	var is_booster:bool = false
	if _data is SkillData:
		if Game.player_manager.has_active_skill(_data.id):
			is_update = true
	else:
		is_booster = true
		if Game.player_manager.has_booster(_data.id):
			is_update = true
			
	if is_update:
		Signals.UpdateActiveSkill.emit(_data.id, is_booster)
	else:
		#Debug.log("Emitting add new skill")
		Signals.AddNewSkill.emit(_data)