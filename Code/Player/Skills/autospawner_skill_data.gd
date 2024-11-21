class_name AutoSpawnerSkillData extends SkillData


@export var to_spawn:PackedScene
@export var monster_data:MonsterData

var spawn_delay:int:
	get: return get_parameter("spawn_delay")
var spawn_count:int:
	get: return get_parameter("spawn_count")
var extra_spawn_chance:float:
	get: return get_parameter("extra_spawn_chance")
