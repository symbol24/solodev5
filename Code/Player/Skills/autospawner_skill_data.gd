class_name AutoSpawnerSkillData extends SkillData


@export var monster_data:SkillData

var spawn_delay:int:
	get: return _get_data("spawn_delay")
var spawned_level:int:
	get: return current_level
var spawn_count:int:
	get: return _get_data("spawn_delay")
var extra_spawn_chance:float:
	get: return _get_data("spawn_delay")
