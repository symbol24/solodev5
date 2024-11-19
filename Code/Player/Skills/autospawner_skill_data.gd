class_name AutoSpawnerSkillData extends SkillData


@export var to_spawn:PackedScene
@export var monster_data:MonsterSkillData

var spawn_delay:int:
	get: return _get_data("spawn_delay")
var spawn_count:int:
	get: return _get_data("spawn_count")
var extra_spawn_chance:float:
	get: return _get_data("extra_spawn_chance")
