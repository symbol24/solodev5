class_name PlayerManager extends Node2D


const DEBUGLEADER = preload("res://Data/Leaders/test_leader.tres")


@export var starting_skill:Array[SkillData]
@export var all_skills:Array[SkillData]

var player_data:PlayerData

# Skills
var active_skill:Skill
var all_active_skills:Array[Skill] = []

var mouse_in_no_click:bool = false
var is_active:bool = false


# if area breaks again, maybe change to check if mouse distance from the center  is larger than radius of light
func _input(event: InputEvent) -> void:
	if not get_tree().paused and is_active:
		if active_skill and event.is_action_pressed("mouse_left"):
			active_skill.trigger_skill(event.position, mouse_in_no_click)

		if event.is_action_pressed("pause"):
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

		get_viewport().set_input_as_handled()


func _ready() -> void:
	Signals.ToggleMouseEnteredNoClickArea.connect(_toggle_mouse_entered)
	Signals.AddExp.connect(_add_exp)
	Signals.PlayerUiReady.connect(_create_starter_skills)
	Signals.ActivateSkill.connect(_set_active_skill)
	Signals.StopRound.connect(_stop_player)
	Signals.ActivatePlayer.connect(_activate_player)
	Signals.AddNewSkill.connect(_create_skill)
	Signals.UpdateActiveSkill.connect(_update_active_skill)
	player_data = PlayerData.new()
	player_data.selected_leader = DEBUGLEADER.duplicate(true)
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


func _toggle_mouse_entered(value:bool) -> void:
	mouse_in_no_click = value
	#Debug.log("Mouse in no click: ", mouse_in_no_click)


func _add_exp(value:int) -> void:
	player_data.add_exp(value)


func _add_run_currency(value:int) -> void:
	player_data.run_currency += value


func _create_starter_skills() -> void:
	for each in starting_skill:
		_create_skill(each, true)


func _create_skill(skill_data:SkillData, is_disabled:bool = false) -> void:
	var new:Skill = load(skill_data.skill_path).instantiate() as Skill
	add_child(new)
	if not new.is_node_ready():
		await new.ready
	new.set_data(skill_data)
	all_active_skills.append(new)
	Signals.ConstructSkillBox.emit(skill_data, is_disabled)


func _update_active_skill(_id:String) -> void:
	for each in all_active_skills:
		if each.data.id == _id:
			each.data.current_level += 1


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
