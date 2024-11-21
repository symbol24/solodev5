extends Node2D


const SKILLLEVELCAP:int = 6

const PLAYERMANAGER = preload("res://Scenes/Utilities/Managers/player_manager.tscn")
const CURRENCYMANAGER = preload("res://Scenes/Utilities/Managers/currency_manager.tscn")
const LEVELUPMANAGER = preload("res://Scenes/Utilities/Managers/level_up_manager.tscn")
const SPAWNMANAGER = preload("res://Scenes/Utilities/Managers/spawn_manager.tscn")


@export var audio_list:AudioList

var player_data:PlayerData

var active_tower:Tower = null
var tower_ready:bool = false
var player_manager:PlayerManager = null
var player_ready:bool = false
var currency_manager:CurrencyManager = null
var cm_ready:bool = false
var level_up_manager:LevelUpManager
var spawn_manager:SpawnManager
var spawn_manager_ready:bool = false
var lup_ready:bool = false
var last_round_result:bool = false


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.TowerReady.connect(_set_tower)
	Signals.TowerClear.connect(_clear_tower)
	Signals.CheckMatchEnd.connect(_chech_end_match)
	Signals.ClearActiveScene.connect(_clear_tower)
	Signals.ManagerReady.connect(_set_manager_ready)


func parse_json_data(_json:String) -> Dictionary:
	var result:Dictionary
	var file = FileAccess.open(_json, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(json_string)
		if error != OK:
			Debug.error("JSON file parsing failed for ", _json)
			return result
		
		result = json.data.duplicate()
		file.close()
	return result


func get_random_from_array(_array:Array, _amount:int = 1) -> Array:
	var result:Array = []

	var x:int = 0
	var real_amount:int = _amount if _array.size() >= _amount else _array.size()
	while x < real_amount:
		var choice:int = randi_range(0, _array.size()-1)
		result.append(_array.pop_at(choice))
		x += 1

	return result


func _set_tower(tower:Tower) -> void:
	Signals.ToggleUi.emit("player_ui")
	active_tower = tower
	tower_ready = true
	player_manager = PLAYERMANAGER.instantiate() as PlayerManager
	add_child(player_manager)
	currency_manager = CURRENCYMANAGER.instantiate() as CurrencyManager
	add_child(currency_manager)
	level_up_manager = LEVELUPMANAGER.instantiate() as LevelUpManager
	add_child(level_up_manager)
	spawn_manager = SPAWNMANAGER.instantiate() as SpawnManager
	add_child(spawn_manager)


func _clear_tower() -> void:
	if self != null:
		active_tower = null
		tower_ready = false
		if player_manager != null:
			player_manager.queue_free()
			player_manager = null
		player_ready = false
		if currency_manager != null:
			currency_manager.queue_free()
			currency_manager = null
		cm_ready = false
		if level_up_manager != null:
			level_up_manager.queue_free()
			level_up_manager = null
		lup_ready = false
		if spawn_manager != null:
			spawn_manager.queue_free()
			spawn_manager = null
		spawn_manager_ready = false
		Signals.ToggleDark.emit(false)
		Signals.ClearPlayerUi.emit()


func _set_manager_ready(manager) -> void:
	if manager is PlayerManager:
		player_ready = true
	elif manager is CurrencyManager:
		cm_ready = true
	elif manager is LevelUpManager:
		lup_ready = true
	elif manager is SpawnManager:
		spawn_manager_ready = true
	_check_all_ready()


func _check_all_ready() -> void:
	if tower_ready and player_ready and cm_ready and lup_ready and spawn_manager_ready:
		if SM.levels.extra_loading_time > 0:
			await get_tree().create_timer(SM.levels.extra_loading_time).timeout
		Signals.ToggleLoadingScreen.emit(false)
		await get_tree().create_timer(1).timeout
		Signals.ActivatePlayer.emit()
		Signals.PressFirstSkillButton.emit()
		Signals.ActivateTower.emit()


func _chech_end_match(_starting_light_radius:float, _current_light_radius:float, _current_push_back_radius:float) -> void:
	var ended:bool = false
	if _current_light_radius > _starting_light_radius:
		if _current_light_radius >= _current_push_back_radius:
			last_round_result = false
			ended = true
	elif _current_light_radius <= _starting_light_radius:
		if _current_push_back_radius <= _current_light_radius:
			last_round_result = true
			ended = true
	
	if ended:
		get_tree().paused = true
		Signals.StopRound.emit()
		Signals.ToggleUi.emit("result_screen")


