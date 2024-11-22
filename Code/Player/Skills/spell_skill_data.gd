class_name SpellSkillData extends SkillData


@export var to_spawn:PackedScene
@export var damages:Array[Damage]

var damage:int:
	get: return get_parameter("damage")
var target_count:int:
	get: return get_parameter("target_count")
var attack_area_size:float:
	get: return get_parameter("attack_area_size")
var projectile_speed:float:
	get: return get_parameter("projectile_speed")
var status_effect_delay:float:
	get: return get_parameter("status_effect_delay")