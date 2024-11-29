class_name PlayerManager extends Node2D


@export var starting_skill:Array[SkillData]
@export var all_skills:Array[SkillData]

var player_data:PlayerData

# Skills
var active_skill:Skill
var all_active_skills:Array[Skill] = []

# Boosters
var all_active_boosters:Array[BoosterData]

var mouse_in_no_click:bool = false
var is_active:bool = false


# if area breaks again, maybe change to check if mouse distance from the center  is larger than radius of light
func _input(event: InputEvent) -> void:
	if not get_tree().paused and is_active:
		if active_skill and event.is_action_pressed("mouse_left"):
			get_viewport().set_input_as_handled()
			active_skill.trigger_skill(event.position, mouse_in_no_click)

		if event.is_action_pressed("pause"):
			get_viewport().set_input_as_handled()
			get_tree().paused = true
			Signals.ToggleUi.emit("pause_menu")
		
		if event.is_action_pressed("1"):
			_set_active_skill_by_key(0)

		if event.is_action_pressed("2"):
			_set_active_skill_by_key(1)

		if event.is_action_pressed("3"):
			_set_active_skill_by_key(2)

		if event.is_action_pressed("4"):
			_set_active_skill_by_key(3)


func _ready() -> void:
	Signals.ToggleMouseEnteredNoClickArea.connect(_toggle_mouse_entered)
	Signals.AddCurrency.connect(_add_currency)
	Signals.AddExp.connect(_debug_add_exp)
	Signals.PlayerUiReady.connect(_create_starter_skills)
	Signals.ActivateSkill.connect(_set_active_skill)
	Signals.StopRound.connect(_stop_player)
	Signals.ActivatePlayer.connect(_activate_player)
	Signals.AddNewSkill.connect(_add_new_selection)
	Signals.UpdateActiveSkill.connect(_update_active_skill)
	player_data = PlayerData.new()
	Signals.UpdatePlayerExp.emit(player_data.current_exp, player_data.get_level_exp_ceiling())
	Signals.ManagerReady.emit(self)


func get_data_by_id(_id:String) -> SkillData:
	for each in all_active_skills:
		if each.data.id == _id: return each.data
	


	for each in all_skills:
		if each.id == _id: return each
	
	return null


func has_active_skill(_id:String) -> bool:
	for each in all_active_skills:
		if each.data.id == _id: return true
	return false


func has_booster(_id:String) -> bool:
	for each in all_active_boosters:
		if each.id == _id: return true
	return false


func get_value_of(_param:String) -> float:
	var result:float = 0
	var bonus:float = 0
	var percent:float = 1
	var params:Array[Parameter] = get_parameters_from_boosters(_param)
	params.append(Game.selected_leader.get_leader_parameter(_param))
	params.append_array(Game.save_load.get_parameter_from_permas(_param))

	for each in params:
		if each != null:
			match each.type:
				Parameter.Type.FLAT:
					result = each.value
				Parameter.Type.FLAT_BONUS:
					bonus += each.value
				Parameter.Type.PERCENT_BONUS:
					percent += each.value

	result = (result + bonus) * percent

	return result


func get_parameters_from_boosters(_param:String) -> Array[Parameter]:
	var result:Array[Parameter] = []

	# for each in all boosters add to result
	for booster in all_active_boosters:
		if booster.get_booster_parameter(_param) != null:
			result.append(booster.get_booster_parameter(_param))

	return result


func _toggle_mouse_entered(value:bool) -> void:
	mouse_in_no_click = value
	#Debug.log("Mouse in no click: ", mouse_in_no_click)


func _debug_add_exp(value:float) -> void:
	player_data.add_exp(value)


func _add_currency(type:CurrencyObject.Type, value:float) -> void:
	if type == CurrencyObject.Type.EXP:
		player_data.add_exp(value)
	else:
		player_data.add_currency(value)


func _add_run_currency(value:int) -> void:
	player_data.run_currency += value


func _create_starter_skills() -> void:
	if Game.selected_leader != null:
		for each in Game.selected_leader.starting_skills:
			_add_new_selection(each, true)


func _add_new_selection(new_data:SytoData, is_disabled:bool = false) -> void:
	var new
	if new_data is SkillData:
		new = load(new_data.skill_path).instantiate() as Skill
		add_child(new)
		if not new.is_node_ready():
			await new.ready
		new.set_data(new_data)
		all_active_skills.append(new)
		Signals.ConstructSkillBox.emit(new_data, is_disabled)
	elif new_data is BoosterData:
		#Debug.log("Received booster data")
		var new_booster:BoosterData = new_data.duplicate(true)
		new_booster.level_datas.clear()
		new_booster.level_datas = new_data.get_duplicate_levels()
		new_booster.current_level = 1
		all_active_boosters.append(new_booster)
		Signals.ConstructBoosterBox.emit(new_data)


func _update_active_skill(_id:String, is_booster:bool = false) -> void:
	#Debug.log("Receiving level up for skill:", _id, " and is booster ", is_booster)
	if is_booster:
		for each in all_active_boosters:
			if each.id == _id: 
				each.current_level += 1
				return
		return
	for each in all_active_skills:
		if each.data.id == _id:
			each.data.current_level += 1
			return


func _set_active_skill(_id:String) -> void:
	for each in all_active_skills:
		if each != null and each.data.id == _id:
			active_skill = each
			return
	Debug.warning("No skill found with id ", _id)


func _set_active_skill_by_key(key:int) -> void:
	if key < all_active_skills.size():
		Signals.ToggleSkillFromKey.emit(all_active_skills[key].data.id)


func _activate_player() -> void:
	is_active = true


func _stop_player() -> void:
	is_active = false
