class_name MonsterData extends SytoData


@export_category("Loading Data")
@export var to_spawn:PackedScene

@export_category("Stats")
@export var damages:Array[Damage] = []
@export var is_flyer:bool = false


var is_dead:bool = false
var current_hp:int = 0:
	set(value):
		if not is_dead:
			current_hp = value
			if current_hp <= 0: 
				is_dead = true
var starting_hp:int:
	get: return get_parameter("hp")
var speed:float:
	get: return get_parameter("speed")
var armor:int:
	get: return get_parameter("armor")
var hit_shield:int:
	get: return get_parameter("hit_shield")
var attack_area_size:float:
	get: return get_parameter("attack_area_size")
var attack_range:float:
	get: return get_parameter("attack_range")
var attack_delay:float:
	get: return get_parameter("attack_delay")
var projectile_speed:float:
	get: return get_parameter("projectile_speed")
var status_effect_delay:float:
	get: return get_parameter("status_effect_delay")


func setup_data() -> void:
	current_level = 1
	is_dead = false
	current_hp = get_parameter("hp")


func get_damages() -> Array[Damage]:
	return damages