class_name TowerData extends TowerSytoData


@export var starting_level:int = 1
@export var starting_dark_radius:float = 160
@export var starting_light_radius:float = 24
@export var starting_light_increase_per_tic:int = 1
@export var starting_level_cap:int = 5
@export var exp_per_tic:float = 0.5
@export var base_damage:int = 1

@export_group("Weapons")
@export var starter_weapons:Array[TowerSytoData] = []
@export var starter_spawners:Array[TowerSytoData]
@export var upgrade_choices:Array[TowerSytoData] = []

var current_increase_per_tic:float:
	get: return get_leveled_value(starting_light_increase_per_tic)
var dark_radius:float = 160
var light_radius:float = 24
var active_weapons:Array[TowerWeapon] = []
var active_spawners:Array[TowerAutospawner] = []
var is_dead:bool = false
var current_exp:int = 0:
	set(value):
		current_exp = value
		_check_level_up()
var temp_exp:float = 0.0:
	set(value):
		temp_exp = value
		if temp_exp >= 1:
			temp_exp = 0
			current_exp += 1
var current_damage:int:
	get: return get_leveled_value(base_damage)
var weapons:Array[TowerWeaponData] = []


func setup_data() -> void:
	is_dead = false
	current_exp = 0
	temp_exp = 0
	current_level = starting_level
	light_radius = starting_light_radius
	dark_radius = starting_dark_radius


func _get_level_exp_cap() -> int:
	return floori(starting_level_cap * (current_level * 0.5)) if current_level > 1 else 1


func _check_level_up() -> void:
	var level_exp:int = _get_level_exp_cap()
	if current_exp >= level_exp:
		current_exp = 0
		current_level += 1