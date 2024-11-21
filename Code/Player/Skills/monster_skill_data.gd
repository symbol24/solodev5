class_name ManualSpawnerSkillData extends SkillData


@export var to_spawn:PackedScene

# Monster
var hp:int:
	get: return get_parameter("hp")
var damage:int:
	get: return get_parameter("damage")
var speed:int:
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