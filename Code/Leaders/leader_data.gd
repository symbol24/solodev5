class_name LeaderData extends SytoData


# General
@export var use_delay:float = 0
@export var luck:float = 0

@export_category("Damage")
@export var unholy:float = 0
@export var corruption:float = 0
@export var backlight_enabled:float = 0
@export var crit_chance:float = 0
@export var crit_damage:float = 0

@export_category("Healing")
@export var healing:float = 0

@export_category("Autospawners")
@export var spawn_delay:float = 0
@export var extra_spawn_chance:float = 0

@export_category("Minions/Bosses")
@export var hp:float = 0
@export var speed:float = 0
@export var armor:float = 0
@export var hit_shield:int = 0
@export var attack_range:float = 0
@export var attack_delay:float = 0