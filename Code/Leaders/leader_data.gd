class_name LeaderData extends SytoData


# General
@export var use_delay:Parameter
@export var luck:Parameter

@export_category("Damage")
@export var damage:Parameter
@export var unholy_damage:Parameter
@export var corruption_damage:Parameter
@export var blight_damage:Parameter
@export var crit_chance:Parameter
@export var crit_damage:Parameter
@export var target_count:Parameter

@export_category("Healing")
@export var healing:Parameter

@export_category("Autospawners")
@export var spawn_delay:Parameter
@export var spawn_count:Parameter
@export var extra_spawn_chance:Parameter

@export_category("Minions/Bosses")
@export var hp:Parameter
@export var speed:Parameter
@export var armor:Parameter
@export var hit_shield:Parameter

@export_category("Attack Area / Projectile")
@export var attack_range:Parameter
@export var attack_delay:Parameter
@export var attack_area_size:Parameter
@export var projectile_speed:Parameter

@export_category("Status Effects")
@export var status_effect_delay:Parameter


func get_parameter(_param:String):
	#Debug.log("Getting ", _param ," Leader Data")
	if get(_param) != null: return get(_param)
	return 0