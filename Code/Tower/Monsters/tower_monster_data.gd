class_name TowerMonsterData extends TowerSytoData


@export var to_spawn:PackedScene
@export var is_unique:bool = false
@export var is_flyer:bool = false
@export var damage_type:Damage.Type

var is_dead:bool = false
var current_hp:int = 0:
	set(value):
		if not is_dead:
			current_hp = value
			if current_hp <= 0: 
				is_dead = true
var starting_hp:int
var speed:float
var armor:int
var hit_shield:int
var attack_area_size:float
var attack_range:float
var attack_delay:float
var projectile_speed:float
var status_effect_delay:float
var damage:int

func setup_data(_level:int = 1) -> void:
	current_level = _level
	is_dead = false
	starting_hp = get_parameter("hp")
	current_hp = get_parameter("hp")
	armor = get_parameter("armor")
	speed = get_parameter("speed")
	hit_shield = get_parameter("hit_shield")
	attack_area_size = get_parameter("attack_area_size")
	attack_range = get_parameter("attack_range")
	attack_delay = get_parameter("attack_delay")
	projectile_speed = get_parameter("projectile_speed")
	status_effect_delay = get_parameter("status_effect_delay")
	damage = get_parameter("damage")


func get_damages() -> Array[Damage]:
	var dmg:Damage = Damage.new()
	dmg.damage_owner = self
	dmg.type = damage_type
	return [dmg]