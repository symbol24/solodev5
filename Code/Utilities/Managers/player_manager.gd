class_name PlayerManager extends Node2D


@export var starting_level_cap:int = 5
@export var starting_skill:Array[SkillData]
@export var all_skills:Array[SkillData]

# Stats
var player_level:int = 1
var current_exp:int = 0
var total_exp:int = 0

# Skills
var active_skill:Skill
var all_active_skills:Array[Skill] = []

var mouse_in_no_click:bool = false
var is_active:bool = false

# if area breaks again, maybe change to check if mouse distance from the center  is larger than radius of light
func _input(event: InputEvent) -> void:
	if not get_tree().paused and is_active:
		if not mouse_in_no_click and active_skill and event.is_action_pressed("mouse_left"):
			active_skill.trigger_skill(event.position)

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

		


func _ready() -> void:
	Signals.ToggleMouseEnteredNoClickArea.connect(_toggle_mouse_entered)
	Signals.AddCurrency.connect(_add_currency)
	Signals.UpdatePlayerExp.emit(current_exp, _get_level_exp_ceiling())
	Signals.PlayerUiReady.connect(_create_starter_skills)
	Signals.ActivateSkill.connect(_set_active_skill)
	Signals.StopRound.connect(_stop_player)
	Signals.ActivatePlayer.connect(_activate_player)
	Signals.AddNewSkill.connect(_create_skill)
	Signals.UpdateActiveSkill.connect(_update_active_skill)
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
	#print("Mouse in no click: ", mouse_in_no_click)


func _add_currency(value:int) -> void:
	total_exp += value
	current_exp += value
	if current_exp >= _get_level_exp_ceiling():
		current_exp -= _get_level_exp_ceiling()
		_level_up()
	Signals.UpdatePlayerExp.emit(current_exp, _get_level_exp_ceiling())


func _get_level_exp_ceiling() -> int:
	return floori(starting_level_cap * (player_level * 0.5)) if player_level > 1 else starting_level_cap


func _level_up() -> void:
	player_level += 1
	print("Player Level up! ", player_level)
	Signals.PlayerlevelUp.emit(player_level)


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
	push_warning("No skill found with id ", _id)


func _set_active_skill_by_key(key:int) -> void:
	if key < all_active_skills.size():
		Signals.ToggleSkillFromKey.emit(all_active_skills[key].data.id)


func _activate_player() -> void:
	is_active = true


func _stop_player() -> void:
	is_active = false
