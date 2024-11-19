class_name MonsterSkillData extends SkillData


@export var to_spawn:PackedScene

# Monster
var hp:int:
	get: return _get_data("hp")
var damage:int:
	get: return _get_data("damage")
var speed:int:
	get: return _get_data("speed")
var armor:int:
	get: return _get_data("armor")
var hit_shield:int:
	get: return _get_data("hit_shield")
var attack_area_size:float:
	get: return _get_data("attack_area_size")
var attack_range:float:
	get: return _get_data("attack_range")
var attack_delay:float:
	get: return _get_data("attack_delay")
var projectile_speed:float:
	get: return _get_data("projectile_speed")
var status_effect_delay:float:
	get: return _get_data("status_effect_delay")